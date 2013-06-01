class Question < ActiveRecord::Base
	include Taggable
	belongs_to :spud_user, :foreign_key => :user_id
	has_many :answers
	has_many :comments, :as => :attachment
	attr_reader :total_votes

	def total_votes
		up_votes = up_votes || 0
		down_votes = down_votes || 0
		return up_votes - down_votes
	end

	def formatted_content
		require 'redcarpet'
	    renderer = Redcarpet::Render::HTML.new
	    extensions = {fenced_code_blocks: true}
	    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
	    redcarpet.render self.content
	end
end
