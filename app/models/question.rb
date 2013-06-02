class Question < ActiveRecord::Base
	include Taggable
	include Votable

	belongs_to :spud_user, :foreign_key => :user_id
	has_many :answers
	has_many :comments, :as => :attachment

	validates :subject, :presence => true
	validates :content, :presence => true

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
