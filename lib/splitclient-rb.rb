require 'forwardable'

require 'splitclient-rb/version'

require 'splitclient-rb/exceptions'
require 'splitclient-rb/cache/routers/impression_router'
require 'splitclient-rb/cache/adapters/memory_adapters/map_adapter'
require 'splitclient-rb/cache/adapters/memory_adapters/queue_adapter'
require 'splitclient-rb/cache/adapters/cache_adapter'
require 'splitclient-rb/cache/adapters/memory_adapter'
require 'splitclient-rb/cache/adapters/redis_adapter'
require 'splitclient-rb/cache/fetchers/segment_fetcher'
require 'splitclient-rb/cache/fetchers/split_fetcher'
require 'splitclient-rb/cache/repositories/repository'
require 'splitclient-rb/cache/repositories/segments_repository'
require 'splitclient-rb/cache/repositories/splits_repository'
require 'splitclient-rb/cache/repositories/events_repository'
require 'splitclient-rb/cache/repositories/impressions_repository'
require 'splitclient-rb/cache/repositories/events/memory_repository'
require 'splitclient-rb/cache/repositories/events/redis_repository'
require 'splitclient-rb/cache/repositories/impressions/memory_repository'
require 'splitclient-rb/cache/repositories/impressions/redis_repository'
require 'splitclient-rb/cache/repositories/metrics_repository'
require 'splitclient-rb/cache/repositories/metrics/memory_repository'
require 'splitclient-rb/cache/repositories/metrics/redis_repository'
require 'splitclient-rb/cache/senders/impressions_formatter'
require 'splitclient-rb/cache/senders/impressions_sender'
require 'splitclient-rb/cache/senders/metrics_sender'
require 'splitclient-rb/cache/senders/events_sender'
require 'splitclient-rb/cache/senders/localhost_repo_cleaner'
require 'splitclient-rb/cache/stores/store_utils'
require 'splitclient-rb/cache/stores/localhost_split_builder'
require 'splitclient-rb/cache/stores/sdk_blocker'
require 'splitclient-rb/cache/stores/localhost_split_store'

require 'splitclient-rb/clients/split_client'
require 'splitclient-rb/managers/split_manager'
require 'splitclient-rb/split_factory'
require 'splitclient-rb/split_factory_builder'
require 'splitclient-rb/split_config'
require 'splitclient-rb/split_logger'
require 'splitclient-rb/validators'
require 'splitclient-rb/split_factory_registry'

require 'splitclient-rb/engine/api/faraday_middleware/gzip'
require 'splitclient-rb/engine/api/faraday_adapter/patched_net_http_persistent'
require 'splitclient-rb/engine/api/client'
require 'splitclient-rb/engine/api/impressions'
require 'splitclient-rb/engine/api/metrics'
require 'splitclient-rb/engine/api/segments'
require 'splitclient-rb/engine/api/splits'
require 'splitclient-rb/engine/api/events'
require 'splitclient-rb/engine/parser/condition'
require 'splitclient-rb/engine/parser/partition'
require 'splitclient-rb/engine/parser/split_adapter'
require 'splitclient-rb/engine/parser/evaluator'
require 'splitclient-rb/engine/matchers/matcher'
require 'splitclient-rb/engine/matchers/combiners'
require 'splitclient-rb/engine/matchers/combining_matcher'
require 'splitclient-rb/engine/matchers/all_keys_matcher'
require 'splitclient-rb/engine/matchers/negation_matcher'
require 'splitclient-rb/engine/matchers/user_defined_segment_matcher'
require 'splitclient-rb/engine/matchers/whitelist_matcher'
require 'splitclient-rb/engine/matchers/equal_to_matcher'
require 'splitclient-rb/engine/matchers/greater_than_or_equal_to_matcher'
require 'splitclient-rb/engine/matchers/less_than_or_equal_to_matcher'
require 'splitclient-rb/engine/matchers/between_matcher'
require 'splitclient-rb/engine/matchers/set_matcher'
require 'splitclient-rb/engine/matchers/part_of_set_matcher'
require 'splitclient-rb/engine/matchers/equal_to_set_matcher'
require 'splitclient-rb/engine/matchers/contains_any_matcher'
require 'splitclient-rb/engine/matchers/contains_all_matcher'
require 'splitclient-rb/engine/matchers/starts_with_matcher'
require 'splitclient-rb/engine/matchers/ends_with_matcher'
require 'splitclient-rb/engine/matchers/contains_matcher'
require 'splitclient-rb/engine/matchers/dependency_matcher'
require 'splitclient-rb/engine/matchers/equal_to_boolean_matcher'
require 'splitclient-rb/engine/matchers/equal_to_matcher'
require 'splitclient-rb/engine/matchers/matches_string_matcher'
require 'splitclient-rb/engine/evaluator/splitter'
require 'splitclient-rb/engine/metrics/metrics'
require 'splitclient-rb/engine/metrics/binary_search_latency_tracker'
require 'splitclient-rb/engine/models/split'
require 'splitclient-rb/engine/models/label'
require 'splitclient-rb/engine/models/treatment'
require 'splitclient-rb/engine/auth_api_client'
require 'splitclient-rb/engine/push_manager'
require 'splitclient-rb/utilitites'

# redis metrics fixer
require 'splitclient-rb/redis_metrics_fixer'

# SSE 
require 'splitclient-rb/sse/event_source/client'
require 'splitclient-rb/sse/event_source/event_types'
require 'splitclient-rb/sse/event_source/status'
require 'splitclient-rb/sse/workers/control_worker'
require 'splitclient-rb/sse/workers/segments_worker'
require 'splitclient-rb/sse/workers/splits_worker'
require 'splitclient-rb/sse/sse_handler'

# C extension
require 'murmurhash/murmurhash_mri'

module SplitIoClient
  def self.root
    File.dirname(__dir__)
  end
end
