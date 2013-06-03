QuestionAndAnswer::Application.routes.draw do

  root to: 'questions#index'

  resources :questions do
    member do
      get 'vote'
    end
    collection do
      get 'unanswered'
      get 'search'
      get 'mine'
    end
  	resources :comments, :only => [:create, :update, :destroy, :index]
  	resources :answers
  end

  resources :answers do
  	member do
  		get 'vote'
      get 'correct'
  	end
  	resources :comments, :only => [:create, :update, :destroy, :index]
  end
end
