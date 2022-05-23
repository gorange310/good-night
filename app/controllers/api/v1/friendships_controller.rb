class Api::V1::FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:friend_id])
    @user.friendships.build(friend: friend)

    if @user.save
      render json: { message: "Following #{friend.name}", data: friend }
    else
      render json: { message: 'Validation failed', errors: @user.errors }, status: :unprocessable_entity
    end
  end

end
