require_relative 'batchifier/exceptions'
require_relative 'batchifier/strategy'
require_relative 'batchifier/add'
require_relative 'batchifier/no_response'
require_relative 'batchifier/array_merge'
require_relative 'batchifier/maintain_unique'
require_relative 'kernel'
require_relative 'proc'
require_relative 'symbol'

module Wor
  module Batchifier
    # This module exports the function execute_in_batches, that needs a collections and
    # => optionaly a batch_size and a merge strategy. It will slice the collection and
    # => apply the chozen strategy to all chunks and merge the results. It expects the responses
    # => to be Hash. It can ignore them if the given strategy is no_response
    def execute_in_batches(collection, batch_size: 100, strategy: :add)
      set_merge_strategy_and_base_case(strategy)
      collection.lazy.each_slice(batch_size).inject(@base_case) do |rec, chunk|
        response = yield(chunk)
        merge(response, rec)
      end
    end

    private

    def merge(response, rec)
      @strategy_method.call(response,rec)
    end

    def set_merge_strategy_and_base_case(strategy)
      @strategy_method = strategy.merge_method
      @base_case = strategy.merge_base_case
    end
  end
end
