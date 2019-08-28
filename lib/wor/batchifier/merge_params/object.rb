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
    end
  end
end
