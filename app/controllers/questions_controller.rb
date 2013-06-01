class QuestionsController < ApplicationController
	before_filter :require_user
	respond_to :html, :json

	def index
		order = params[:order] || "updated_at DESC"
		page  = params[:page] || 1

		@questions = Question.order(order).paginate :page => page
		respond_with @questions
	end

	def show
		@question = Question.find(params[:id])
		respond_with @question
	end

	def new
		@question = Question.new(:spud_user => @current_user)
		respond_with @question
	end

	def create
		@question = Question.new(question_params)
		@question.spud_user = @current_user
		@question.save
		respond_with @question
	end

	def edit
		@question = Question.find(params[:id])
		respond_with @question
	end

	def update
		@question = Question.find(params[:id])
		@question.update_attributes(question_params)
		respond_with @question
	end

	def destroy

	end

private
	def question_params
		params.require(:question).permit(:subject,:content,:tag_string)
	end
end
