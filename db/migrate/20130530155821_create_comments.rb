class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :attachment_type
      t.integer :attachment_id
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
