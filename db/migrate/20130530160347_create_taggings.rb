class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
	  t.string :attachment_type
      t.integer :attachment_id
      t.integer :tag_id
      t.timestamps
    end
  end
end
