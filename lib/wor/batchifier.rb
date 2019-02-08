# frozen_string_literal: true
module Wor
  module Batchifier
    class WrongStrategy < StandardError; end

    # This module exports the function execute_in_batches, that needs a collections and
    # => optionaly a batch_size and a merge strategy. It will slice the collection and
    # => apply the given block to all chunks and merge the results. It expects the responses
    # => to be Hash. It can ignore them if the given stragegy is no_response
    def execute_in_batches(collection, batch_size: 100, strategy: :add)
      collection.each_slice(batch_size).to_a.inject({}) do |rec, chunk|
        response = yield(chunk)
        merge(response, rec, strategy)
      end
    end

    protected

    def merge(response, rec, strategy)
      return rec.merge(response) { |_, v1, v2| v1 + v2 } if strategy == :add
      return rec.merge(response) { |_, v1, _| v1 } if strategy == :maintain_unique
      return {} if strategy == :no_response
      raise WrongStrategy
    end
  end
end
