class Answer < ActiveRecord::Base
	include Votable

	belongs_to :question
	belongs_to :spud_user, :foreign_key => :user_id
	has_many :comments, :as => :attachment


	def formatted_content
		if self.content.blank?
			return ''
		end
		require 'redcarpet'
	    renderer = Redcarpet::Render::HTML.new
	    extensions = {fenced_code_blocks: true}
	    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
	    redcarpet.render self.content
	end
end
