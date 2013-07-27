class Question < ActiveRecord::Base
	include Tire::Model::Search
	include Tire::Model::Callbacks
	include Taggable
	include Votable
	# include ThinkingSphinx::Scopes

  mapping do
    indexes :id, :index    => :not_analyzed
    indexes :subject, :analyzer => 'snowball', :boost => 100
    indexes :content, :analyzer => 'snowball'
    indexes :created_at, :type => 'date'
    indexes :user_id , :index => :not_analyzed
	  indexes :up_votes, :index => :not_analyzed
	  indexes :down_votes, :index => :not_analyzed

    indexes :tags do
      indexes :name, :analyzer => 'keyword'
    end
  end


	belongs_to :spud_user, :foreign_key => :user_id
	has_many :answers
	has_many :comments, :as => :attachment

	validates :subject, :presence => true
	validates :content, :presence => true

	scope :unanswered, joins("LEFT JOIN answers on answers.question_id = questions.id").group("questions.id").having("count(answers.id) = 0")

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

	def self.search(phrase)
	  tire.search(load: true) do
	    query { string phrase, default_operator: "AND" } if phrase.present?
	    # filter :range, published_at: {lte: Time.zone.now}
	  end
	end
end
