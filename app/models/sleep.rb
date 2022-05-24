class Sleep < ApplicationRecord
  belongs_to :user

  scope :in_past_week, -> { where('created_at >= ?', 1.week.ago) }
  scope :with_length, -> { where.not(seconds: nil) }

  def active?
    self.seconds.nil?
  end
end
