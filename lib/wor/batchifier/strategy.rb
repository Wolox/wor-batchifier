module Wor
  module Batchifier
    class Strategy

      def merge_strategy
        raise Wor::Batchifier::Exceptions::InterfaceNotImplemented.new "Class #{self.class.name} does not implement contract merge_strategy!"
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
