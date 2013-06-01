class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.text :content
      t.integer :up_votes, :default => 0
      t.integer :down_votes, :default => 0
      t.integer :user_id
      t.boolean :answered

      t.timestamps
    end
  end
end
