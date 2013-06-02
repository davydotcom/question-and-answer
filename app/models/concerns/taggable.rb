module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :attachment, dependent: :destroy
    has_many :tags, through: :taggings
  end

  def tag_names
    tags.map(&:name)
  end

  def tag_string=(data)
  	tagArray = data.split(",")
  	tagArray.each do |tag|
  		tagRecord = Tag.where(:name => tag.truncate).first
  		if !tagRecord
  			tagRecord = Tag.new(:name => tag.truncate)
  		end
  		tagRecord.save
  		self.tags << tagRecord
  	end
  end

  def tag_string
  	tag_names().join(", ")
  end
end
