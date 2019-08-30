module Wor
  module Batchifier
    class ArrayMerge < Strategy
      def merge_strategy(response,memo)
        memo = [] if memo.empty?
        return memo + response
      end
    end
  end
end
