class User < ApplicationRecord
  has_many :sleeps, -> { order(:created_at) }
end
