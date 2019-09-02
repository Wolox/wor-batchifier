module Wor
  module Batchifier
    module MergeParams
      refine Proc do
        def merge_method
          self
        end

        def merge_base_case
          {}
        end
      end
    end
  end
end
