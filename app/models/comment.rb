class Comment < ActiveRecord::Base
	belongs_to :spud_user, :foreign_key => :user_id
	belongs_to :attachment, :polymorphic => true
end
