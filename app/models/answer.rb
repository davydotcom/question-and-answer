class Answer < ActiveRecord::Base
	belongs_to :question
	belongs_to :spud_user, :foreign_key => :user_id
	has_many :comments, :as => :attachment

	def total_votes
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
