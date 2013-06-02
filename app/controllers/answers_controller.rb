class AnswersController < ApplicationController
	respond_to :json, :html
	before_filter :load_question, :except => :vote

	def create
		@answer = @question.answers.new(answer_params)
		@answer.spud_user = @current_user
		@answer.save
		respond_with @answer, :location => question_url(:id => @question.id)
	end

	def update
		@answer = @question.answers.find(params[:id])
		@answer.update_attributes(answer_params)
		respond_with @answer, :location => question_url(:id => @question.id)
	end

	def destroy
		@answer = @question.answers.find(params[:id])
		if @answer.user_id == @current_user.id
			@answer.destroy
		end
		respond_with @answer, :location => question_url(:id => @question.id)
	end

	def vote
		@answer = Answer.find(params[:id])
		response = @answer.vote(@current_user, params[:value])
		redirect_to :back and return
	end

private
	def load_question
		@question = Question.find(params[:question_id])
	end

	def answer_params
		params.require(:answer).permit(:content)
	end
end
