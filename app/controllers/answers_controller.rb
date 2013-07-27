class AnswersController < ApplicationController
	respond_to :json, :html
	before_filter :load_question, :except => [:vote,:correct]

	def create
		@answer = @question.answers.new(answer_params)
		@answer.spud_user = @current_user
		if @answer.save
        NotificationMailer.question_answered_notification(@question,@answer).deliver
		end
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

	def correct
		@answer = Answer.find(params[:id])
		@question = @answer.question

		if @question.user_id != @current_user.id
			flash[:error] = "You must be the owner of the question to mark it."
		else
			@previously_marked_answer = @question.answers.where(:answered => true).first
			@previously_marked_answer.update_attributes(:answered => false) if @previously_marked_answer
			@answer.answered = true
			if @answer.save
        NotificationMailer.answer_correct(@answer).deliver
			end
		end
		redirect_to :back
	end

private
	def load_question
		@question = Question.find(params[:question_id])
	end

	def answer_params
		params.require(:answer).permit(:content)
	end
end
