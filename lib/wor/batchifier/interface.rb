module Wor
  module Batchifier
    module Interface
      attr_writer :contract

      def implements(*selectors)
        self.contract += selectors
      end

      def contract
        @contract ||= []
      end

      def full_contract
        (contract + ancestors.flat_map(&:contract)).uniq
      end

      def breaches_contract?
        full_contract.any? { |it| !method_defined? it }
      end
    end
  end
end
