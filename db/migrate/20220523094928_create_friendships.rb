class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.integer :user_id, :index => true, :null => false
      t.integer :friend_id, :index => true, :null => false

      t.timestamps
    end
  end
end
