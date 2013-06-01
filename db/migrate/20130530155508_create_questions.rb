class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :subject
      t.text :content
      t.integer :user_id
      t.integer :up_votes, :default => 0
      t.integer :down_votes, :default => 0

      t.timestamps
    end
  end
end
