class Tagging < ActiveRecord::Base
	belongs_to :attachment, :polymorphic => true
	belongs_to :tag
end
