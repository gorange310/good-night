class CreateSleeps < ActiveRecord::Migration[7.0]
  def change
    create_table :sleeps do |t|
      t.integer :user_id, :null => false, :index => true
      t.integer :seconds, :index => true

      t.timestamps
    end

    add_index :sleeps, :created_at
  end
end
