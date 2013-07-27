class NotificationMailer < ActionMailer::Base
  default from: "no-reply@bertramlabs.com"

  def question_answered_notification(question,answer)
  	@user = question.spud_user
  	@answer = answer
    @url = question_url(:id => @question.id, :anchor => "answer_#{answer.id}")
  	@subject = "[Question & Answer] Question Answered - #{question.subject}"
  	mail(:to => @user.email, :subject => @subject)
  end

  def answer_correct(answer)
  	@answer = answer
  	@user = @answer.spud_user
  	@question = @answer.question
  	@subject = "[Question & Answer] Your Answer was marked as correct - #{answer.question.subject}"
  	mail(:to => @user.email, :subject => @subject)
  end
end
