class Sleep < ApplicationRecord
  belongs_to :user

  def active?
    self.seconds.nil?
  end
end
