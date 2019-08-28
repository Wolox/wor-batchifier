module Wor
  module Batchifier
    module MergeParams
      refine Object do
        def merge_method
          raise Wor::Batchifier::Exceptions::InvalidStrategyType
        end

        def merge_base_case
          raise Wor::Batchifier::Exceptions::InvalidStrategyType
        end
      end

      refine Proc do
        def merge_method
          self
        end

        def merge_base_case
          {}
        end
      end

      refine Symbol do
        def merge_method
          classify_strategy.new.method(:merge_strategy)
        end

        def merge_base_case
          classify_strategy.new.base_case
        end

        private

        def classify_strategy
          strategy_class_name = to_s.split('_').collect(&:capitalize).join
          Kernel.const_get("Wor::Batchifier::#{strategy_class_name}")
        rescue NameError => e
          raise Wor::Batchifier::Exceptions::StrategyNotFound
        end
      end
    end
  end
end
