module Wor
  module Batchifier
    class NoResponse < Strategy
      def merge_strategy(_response, _memo)
        return {}
      end
    end
  end
end
