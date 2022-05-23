class User < ApplicationRecord
  has_many :sleeps, -> { order(:created_at) }
  has_many :friendships
  has_many :friends, through: :friendships
end
