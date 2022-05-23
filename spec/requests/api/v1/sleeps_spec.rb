require 'rails_helper'

RSpec.describe 'Api::V1::Sleeps', type: :request do
  fixtures :all

  describe 'GET /api/v1/sleeps' do
    let(:user) { users(:user2) }
    subject(:get_sleeps) { get '/api/v1/sleeps', params: { user_name: user_name } }

    context 'a valid user_name' do
      let(:user_name) { user.name }
      it "should return 200 and user's sleeps record by created_at" do
        get_sleeps
        result = JSON.parse(response.body)
        created_at = result['data'].map { |sleep| sleep['created_at'] }
        expect(response).to have_http_status(:success)
        expect(response.status).to eq(200)
        expect(user.sleeps.size).to eq(3)
        expect(result['data'].size).to eq(3)
        expect(created_at).to match_array(['2022-05-21T00:00:00.000Z', '2022-05-22T00:00:00.000Z', '2022-05-23T00:00:00.000Z'])
      end
    end
  end
end
