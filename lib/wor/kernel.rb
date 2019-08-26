Kernel.class_eval do
  def merge_method
    raise Wor::Batchifier::Exceptions::InvalidStrategyType
  end

  def merge_base_case
    raise Wor::Batchifier::Exceptions::InvalidStrategyType
  end
end
