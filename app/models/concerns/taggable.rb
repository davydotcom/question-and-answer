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
    self.taggings.each do |tagging|
      tagging.destroy
    end
  	tagArray = data.split(",")
  	tagArray.each do |tag|
  		tagRecord = Tag.where(:name => tag.strip).first
  		if !tagRecord
  			tagRecord = Tag.new(:name => tag.strip)
        tagRecord.save

  		end
      self.tags << tagRecord
  	end
  end

  def tag_string
  	tag_names().join(", ")
  end
end
