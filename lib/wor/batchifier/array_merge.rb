module Wor
  module Batchifier
    class ArrayMerge < Strategy
      def merge_strategy(response,rec)
        rec = [] if rec.empty?
        return rec + response
      end
    end
  end
end
