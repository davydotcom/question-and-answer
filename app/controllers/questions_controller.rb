class QuestionsController < ApplicationController
	before_filter :require_user
	respond_to :html, :json

	def index
		order = params[:order] || "updated_at DESC"
		page  = params[:page] || 1

		@questions = Question.order(order).includes(:answers).paginate :page => page
		respond_with @questions
	end

	def search
		@results = Question.search params[:phrase]
		respond_with @results
	end

	def unanswered
		order = params[:order] || "updated_at DESC"
		page  = params[:page] || 1

		@questions = Question.unanswered.includes(:answers).order(order).paginate :page => page
		render :action => "index"
	end

	def mine
		order = params[:order] || "updated_at DESC"
		page  = params[:page] || 1

		@questions = Question.where(:user_id => @current_user.id).order(order).includes(answers).paginate :page => page
		render :action => "index"
	end

	def tags
		order = params[:order] || "updated_at DESC"
		page  = params[:page] || 1

		# @questions = Question.tags(params[:id]).order(order).includes(answers).paginate :page => page
		render :action => "index"
	end

	def show
		@question = Question.find(params[:id])
		@answers = @question.answers.order(:created_at).all
		@answer = @question.answers.new
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
		@question = Question.find(params[:id])
		if @question.spud_user != @current_user
			flash[:error] = "You do not have permission to remove this question!"
			redirect_to request.referer || questions_url
			return
		end

		@question.destroy

		respond_with @question
	end

	def vote
		@question = Question.find(params[:id])
		response = @question.vote(@current_user, params[:value])
		redirect_to :back
	end

private
	def question_params
		params.require(:question).permit(:subject,:content,:tag_string)
	end
end
