module Wor
  module Batchifier
    module Exceptions
      class WrongStrategy < StandardError; end
      class ExistingStrategy < StandardError; end
      class InterfaceNotImplemented < StandardError; end
      class StrategyNotFound < StandardError; end
      class InvalidStrategyType < StandardError; end
    end
  end
end
