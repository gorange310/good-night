require 'rails_helper'

RSpec.describe "Api::V1::Friendships", type: :request do
  fixtures :all

  xdescribe 'POST /api/v1/friendships' do
    subject(:post_friendships) { post '/api/v1/friendships', params: { user_name: user.name, friend_id: friend.id } }
    context "there's valid friend id" do
      let(:user) { users(:user1) }
      let(:friend) { users(:user2) }
      it 'should return 200 and new friend' do
        expect(user.friends.size).to eq(0)

        expect { post_friendships }.to change(Friendship, :count).by(1)
        result = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response.status).to eq(200)
        expect(result['data']).to be_present
        expect(result['data']['name']).to eq(friend.name)
      end
    end

    context "there's invalid friend id (user themself)" do
      let(:user) { users(:user1) }
      let(:friend) { users(:user1) }
      it 'should return 422 and no new friend' do
        expect { post_friendships }.to change(Friendship, :count).by(0)
        result = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.status).to eq(422)
        expect(result['data']).to be_nil
      end
    end
  end

  xdescribe 'DELETE /api/v1/friendships' do
    subject(:delete_friendships) { delete "/api/v1/friendships/#{friend.id}", params: { user_name: user.name } }
    context "there's valid friend id" do
      let(:user) { users(:user2) }
      let(:friend) { users(:user1) }
      it 'destroys the requested friendships' do
        expect(user.friends.size).to eq(1)

        expect { delete_friendships }.to change(Friendship, :count).by(-1)
        result = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response.status).to eq(200)
        expect(result['data']).to be_nil
      end
    end

    context "there's invalid friend id" do
      let(:user) { users(:user2) }
      let(:friend) { users(:user2) }
      it 'destroys the requested friendships' do
        expect(user.friends.size).to eq(1)

        expect { delete_friendships }.to change(Friendship, :count).by(0)
        result = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response.status).to eq(404)
        expect(result['data']).to be_nil
      end
    end
  end

  describe 'GET /api/v1/friendships' do
    subject(:get_friendships) { get '/api/v1/friendships/', params: { user_name: user.name } }
    context "there's valid user_name and friends" do
      let(:user) { users(:user3) }
      it 'get friends sleep records in past week order by length of their sleep' do
        travel_to Time.zone.local(2022, 5, 24)
        expect(user.friends.size).to eq(3)
        get_friendships
        result = JSON.parse(response.body)
        seconds = result['data'].map { |sleep| sleep['seconds'] }
        created_at = result['data'].map { |sleep| sleep['created_at'] }

        expect(response).to have_http_status(:success)
        expect(result['data'].size).to eq(5)
        expect(seconds).to match_array([1800, 25000, 26000, 28800, 29000])
        expect(created_at).to match_array(['2022-05-20T00:00:00.000Z', '2022-05-23T00:00:00.000Z', '2022-05-21T00:00:00.000Z', '2022-05-22T00:00:00.000Z', '2022-05-18T00:00:00.000Z'])
      end
    end
  end
end
