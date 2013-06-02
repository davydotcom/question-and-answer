class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.string :attachment_type
      t.integer :attachment_id
      t.integer :vote

      t.timestamps
    end
  end
end
