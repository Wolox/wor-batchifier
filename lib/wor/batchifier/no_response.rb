module Wor
  module Batchifier
    class NoResponse < Strategy
      def merge_strategy(_response, _rec)
        return {}
      end
    end
  end
end
