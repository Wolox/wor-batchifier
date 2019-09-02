module Wor
  module Batchifier
    class MaintainUnique < Strategy
      def merge_strategy(response,memo)
        return response.merge(memo) { |_, v1, _| v1 }
      end
    end
  end
end
