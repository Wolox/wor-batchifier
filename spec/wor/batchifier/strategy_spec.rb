# frozen_string_literal: true

require 'spec_helper'
include Wor::Batchifier::Interface

describe Wor::Batchifier::Strategy do
  context 'when creating a invalid strategy' do
    it 'should raise any exception when obtaining the merge_strategy' do
      expect { Wor::Batchifier::WrongStrategy.new.merge_strategy }.to raise_error(Wor::Batchifier::Exceptions::InterfaceNotImplemented)
    end
  end

  context 'when creating a valid strategy' do
    it 'should not raise any exception when obtaining the merge_strategy' do
      expect { Wor::Batchifier::ValidStrategy.new.merge_strategy }.not_to raise_error
    end
  end
end
