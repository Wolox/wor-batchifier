module Wor
  module Batchifier
    class MaintainUnique < Strategy
      def merge_strategy(response,rec)
        return response.merge(rec) { |_, v1, _| v1 }
      end
    end
  end
end
