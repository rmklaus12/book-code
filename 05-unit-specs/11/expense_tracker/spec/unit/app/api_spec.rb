require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods
    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    let(:app) { API.new(ledger: ledger) }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        let(:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)

          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end
      end

      context 'when the expense fails validation' do
        let(:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('error' => 'Expense incomplete')
        end
      end
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        it 'responds with a 200'
        it 'returns the expense records as JSON'
      end

      context 'when there are no expenses on the given date' do
        it 'responds with a 200'
        it 'returns an empty array as JSON'
      end
    end
  end
end
