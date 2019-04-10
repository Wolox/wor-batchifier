module Wor
  module Batchifier
    class Strategy
      extend Wor::Batchifier::Interface

      implements :merge_strategy

      class << self
        alias_method :__new__, :new

        def new(*args)
          raise Wor::Batchifier::Exceptions::InterfaceNotImplemented.new "class #{name} does not implement contract #{contract}!" if breaches_contract?
          __new__(*args)
        end
      end

      def base_case
        {}
      end

      # When defining your own strategy for merging, you should define a new class that extends from
      # this class, "Strategy", and implement the method "merge_strategy" which will take care
      # of parsing the response of the batchified endpoint.
      # Should you not implement the method "merge_strategy" the exception "InterfaceNotImplemented"
      # will be raised to notify the developer of such issue.
    end
  end
end
