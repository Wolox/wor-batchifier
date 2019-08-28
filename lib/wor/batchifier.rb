require_relative 'batchifier/exceptions'
require_relative 'batchifier/strategy'
require_relative 'batchifier/add'
require_relative 'batchifier/no_response'
require_relative 'batchifier/array_merge'
require_relative 'batchifier/maintain_unique'
require_relative 'batchifier/merge_params/object'
require_relative 'batchifier/merge_params/symbol'
require_relative 'batchifier/merge_params/proc'

module Wor
  module Batchifier
    using MergeParams
    # This module exports the function execute_in_batches, that needs a collections and
    # => optionaly a batch_size and a merge strategy. It will slice the collection and
    # => apply the chozen strategy to all chunks and merge the results. It expects the responses
    # => to be Hash. It can ignore them if the given strategy is no_response
    def execute_in_batches(collection, batch_size: 100, strategy: :add)
      collection.lazy.each_slice(batch_size).inject(strategy.merge_base_case) do |rec, chunk|
        response = yield(chunk)
        merge(strategy.merge_method, response, rec)
      end
    end

    private

    def merge(merge_method, response, rec)
      merge_method.call(response,rec)
    end
  end
end
