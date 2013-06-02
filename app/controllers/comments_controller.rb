class CommentsController < ApplicationController
	before_filter :load_attachment
	respond_to :json

	def index
		@comments = Comment.where(:attachment => @attachment).paginate :page => params[:page]
		respond_with @comments
	end

	def create
		@comment = Comment.new(comment_params)
		@comment.attachment = @attachment
		@comment.spud_user = @current_user
		@comment.save
		respond_with @comment
	end

	def update
		@comment = Comment.find(params[:id])
		if(@comment.user_id != @current_user.id)
			render :status => 403 and return
		end
		@comment.update_attributes(comment_params)
		respond_with @comment
	end

	def destroy
		@comment = Comment.find(params[:id])
		if(@comment.user_id != @current_user.id)
			render :status => 403 and return
		end

		@comment.destroy
		respond_with @comment
	end

private
	def load_attachment
		if params[:question_id]
			@attachment_tyoe = "Question"
			@attachment = Question.find(params[:question_id])
		elsif params[:answer_id]
			@attachment_tyoe = "Answer"
			@attachment = Answer.find(params[:question_id])
		else
			render :status => 500, :json => {success:false, message: "Please specify a commentable attachment"}
			return false
		end
	end

	def comment_params
		params.require(:comment).permit(:content)
	end
end
