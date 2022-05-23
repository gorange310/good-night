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

  def create
    @sleep = UserClockInService.new(@user).call

    if @sleep.active?
      render json: { message: 'Start recoding sleep', data: @sleep }
    else
      render json: { message: "Slep from #{@sleep.created_at} for #{@sleep.seconds} seconds", data: @sleep }
    end
  end
end
