class Api::V1::SleepsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sleeps = @user.sleeps

    render json: {
      data: @sleeps.map { |sleep|
        {
          seconds: sleep.seconds,
          created_at: sleep.created_at
        }
      }
    }
  end

end
