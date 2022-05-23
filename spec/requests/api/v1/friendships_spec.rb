require 'rails_helper'

RSpec.describe "Api::V1::Friendships", type: :request do
  fixtures :all

  describe 'POST /api/v1/friendships' do
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

  describe 'DELETE /api/v1/friendships' do
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
end
