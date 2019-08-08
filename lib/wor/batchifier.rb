require_relative 'batchifier/exceptions'
require_relative 'batchifier/strategy'
require_relative 'batchifier/add'
require_relative 'batchifier/no_response'
require_relative 'batchifier/array_merge'
require_relative 'batchifier/maintain_unique'

module Wor
  module Batchifier

    # This module exports the function execute_in_batches, that needs a collections and
    # => optionaly a batch_size and a merge strategy. It will slice the collection and
    # => apply the chozen strategy to all chunks and merge the results. It expects the responses
    # => to be Hash. It can ignore them if the given strategy is no_response
    def execute_in_batches(collection, batch_size: 100, strategy: :add, &block)
      strategy_class = classify_strategy(strategy)
      collection.lazy.each_slice(batch_size).inject(strategy_class.new.base_case) do |rec, chunk|
        response = batch_process(chunk, strategy, &block) if block_given?
        merge(response, rec, strategy)
      end
    end

    private

    def batch_process(chunk, strategy)
      yield chunk
    rescue StandardError => e
      logger.error "Custom Merge Strategy from #{classify_strategy(strategy).name} \
                    raised #{e.class.name} during execution."
      e.backtrace.each { |line| logger.error line }
      raise Wor::Batchifier::Exceptions::CustomStrategyMergingError
    end

    def merge(response, rec, strategy)
      return classify_strategy(strategy).new.merge_strategy(response,rec)
    end

    def classify_strategy(strategy)
      strategy_class_name = strategy.to_s.split('_').collect(&:capitalize).join
      Kernel.const_get("Wor::Batchifier::#{strategy_class_name}")
    rescue NameError => e
      raise Wor::Batchifier::Exceptions::StrategyNotFound
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
