module Wor
  module Batchifier
    class Add < Strategy
      def merge_strategy(response,memo)
        return response.merge(memo) { |_, v1, v2| v1 + v2 }
      end
    end
  end
end
