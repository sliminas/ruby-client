module SplitIoClient
  module Cache
    module Fetchers
      class SplitFetcher
        attr_reader :splits_repository

        def initialize(splits_repository, api_key, config, sdk_blocker, telemetry_runtime_producer)
          @splits_repository = splits_repository
          @api_key = api_key
          @config = config
          @sdk_blocker = sdk_blocker
          @semaphore = Mutex.new
          @telemetry_runtime_producer = telemetry_runtime_producer
        end

        def call
          if ENV['SPLITCLIENT_ENV'] == 'test'
            fetch_splits
          else
            splits_thread

            if defined?(PhusionPassenger)
              PhusionPassenger.on_event(:starting_worker_process) do |forked|
                splits_thread if forked
              end
            end
          end
        end

        def fetch_splits(cache_control_headers = false)
          @semaphore.synchronize do
            data = splits_since(@splits_repository.get_change_number, cache_control_headers)

            data[:splits] && data[:splits].each do |split|
              add_split_unless_archived(split)
            end

            @splits_repository.set_segment_names(data[:segment_names])
            @splits_repository.set_change_number(data[:till])

            @config.logger.debug("segments seen(#{data[:segment_names].length}): #{data[:segment_names].to_a}") if @config.debug_enabled

            @sdk_blocker.splits_ready!

            data[:segment_names]
          end
        rescue StandardError => error
          @config.log_found_exception(__method__.to_s, error)
        end

        def stop_splits_thread
          SplitIoClient::Helpers::ThreadHelper.stop(:split_fetcher, @config)
        end

        private

        def splits_thread
          @config.threads[:split_fetcher] = Thread.new do
            @config.logger.info('Starting splits fetcher service') if @config.debug_enabled
            loop do
              fetch_splits

              sleep_for = SplitIoClient::Cache::Stores::StoreUtils.random_interval(@config.features_refresh_rate)
              @config.logger.debug("Splits fetcher is sleeping for: #{sleep_for} seconds") if @config.debug_enabled
              sleep(sleep_for)
            end
          end
        end

        def splits_since(since, cache_control_headers = false)
          splits_api.since(since, cache_control_headers)
        end

        def add_split_unless_archived(split)
          if Engine::Models::Split.archived?(split)
            @config.logger.debug("Seeing archived split #{split[:name]}") if @config.debug_enabled

            remove_archived_split(split)
          else
            store_split(split)
          end
        end

        def remove_archived_split(split)
          @config.logger.debug("removing split from store(#{split})") if @config.debug_enabled

          @splits_repository.remove_split(split)
        end

        def store_split(split)
          @config.logger.debug("storing split (#{split[:name]})") if @config.debug_enabled

          @splits_repository.add_split(split)
        end

        def splits_api
          @splits_api ||= SplitIoClient::Api::Splits.new(@api_key, @config, @telemetry_runtime_producer)
        end
      end
    end
  end
end
