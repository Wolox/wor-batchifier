# frozen_string_literal: true

require 'spec_helper'

describe Wor::Batchifier do
  describe 'execute_in_batches' do
    context 'When executing batch requests' do
      let(:ids) { Array.new(100) { rand(1...9) } }
      let(:body) do
        {
          key1: [1], key2: [2], key3: [3], key4: [4], key5: [5]
        }.to_json
      end

      before do
        stub_request(:post, /.*some_example_request.*/)
          .to_return(status: 200, body: body, headers: {})
      end

      context 'with add strategy' do
        let(:expected_response) do
          {
            'key1' => [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            'key2' => [2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
            'key3' => [3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
            'key4' => [4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
            'key5' => [5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
          }
        end

        let(:batchified_request) do
          execute_in_batches(ids, batch_size: 10) do |chunk|
            resp = HTTParty.post('https://some_example_request.com',
                                 body: { ids: chunk })
            JSON.parse resp.body
          end
        end

        it 'it makes a request per batch' do
          batchified_request
          expect(a_request(:post, 'https://some_example_request.com'))
            .to have_been_made.times(10)
        end

        it 'adds the responses of every batch' do
          expect(batchified_request).to eq(expected_response)
        end
      end

      context 'with unique strategy' do
        let(:expected_response) do
          {
            'key1' => [1],
            'key2' => [2],
            'key3' => [3],
            'key4' => [4],
            'key5' => [5]
          }
        end
        let(:batchified_request) do
          execute_in_batches(ids, batch_size: 10,
                                  strategy: :maintain_unique) do |chunk|
            resp = HTTParty.post('https://some_example_request.com',
                                 body: { ids: chunk })
            JSON.parse resp.body
          end
        end
        it 'it makes a request per batch' do
          batchified_request
          expect(a_request(:post, 'https://some_example_request.com'))
            .to have_been_made.times(10)
        end

        it 'maintains the unique reponse' do
          expect(batchified_request).to eq(expected_response)
        end
      end
      context 'with no response strategy' do
        let(:expected_response) { {} }
        let(:batchified_request) do
          execute_in_batches(ids, batch_size: 10,
                                  strategy: :no_response) do |chunk|
            resp = HTTParty.post('https://some_example_request.com',
                                 body: { ids: chunk })
            JSON.parse resp.body
          end
        end
        it 'it makes a request per batch' do
          batchified_request
          expect(a_request(:post, 'https://some_example_request.com'))
            .to have_been_made.times(10)
        end

        it 'returns empty response' do
          expect(batchified_request).to eq(expected_response)
        end
      end
      context 'with a inexistent strategy' do
        let(:batchified_request) do
          execute_in_batches(ids, batch_size: 10,
                                  strategy: :inexistent_strategy) do |chunk|
            resp = HTTParty.post('https://some_example_request.com',
                                 body: { ids: chunk })
            JSON.parse resp.body
          end
        end

        it 'raises a StrategyNotFound exception' do
          expect { batchified_request }.to raise_error(Wor::Batchifier::Exceptions::StrategyNotFound)
        end
      end

      context 'when array_merge strategy' do
        let(:batchified_process) do
          execute_in_batches(ids,batch_size: 10,
                                 strategy: :array_merge) do |chunk|
            chunk.map { |id| id + 10 }
          end
        end

        let(:expected_response) { ids.map { |id| id + 10} }

        it 'returns the expected result' do
          expect(batchified_process).to eq(expected_response)
        end
      end

      context 'when an error occurs while processing' do
        let(:batchified_process) do
          execute_in_batches(ids,batch_size: 10,
                                 strategy: :array_merge) do |chunk|
            chunk.map { |id| id / 0 }
          end
        end

        it 'raises a ProcessingError exception' do
          expect { batchified_process }.to raise_error(Wor::Batchifier::Exceptions::ProcessingError)
        end
      end
    end
  end
end
