class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', :foreign_key => :friend_id

  validates :friend_id, uniqueness: { scope: :user_id }

  validate :check_friend_is_other_users

  private

  def check_friend_is_other_users
    if self.friend_id == self.user_id
      errors.add(:friend_id, 'cannot follow user self')
    end
  end
end
