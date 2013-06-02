class Vote < ActiveRecord::Base
	belongs_to :spud_user, :foreign_key => :user_id
	belongs_to :attachment, :polymorphic => true

	validates :user_id , :presence => true
	validates :vote, :inclusion => { :in => [-1,1] }
end
