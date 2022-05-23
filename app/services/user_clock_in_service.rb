class UserClockInService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    clock_in_operation
  end

  private

  def clock_in_operation
    last_sleep = user.sleeps.find_or_initialize_by(seconds: nil)
    last_sleep.seconds = (Time.now - last_sleep.created_at) if last_sleep.persisted?
    last_sleep.save!

    last_sleep
  end
end
