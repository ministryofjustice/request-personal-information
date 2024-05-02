Rails.application.routes.draw do
  get "ping", to: "ping#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resource :request do
    get :back
  end

  get "subject" => "requests#show"
  get "subject-name" => "requests#show"

  root to: "pages#homepage"

  if Rails.env.test?
    namespace :test do
      resource :session, only: %i[create]
    end
  end
end
