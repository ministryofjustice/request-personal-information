Rails.application.routes.draw do
  get "ping", to: "ping#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resource :request do
    get :back
  end

  get "subject" => "requests#show"
  get "subject-name" => "requests#show"
  get "subject-date-of-birth" => "requests#show"
  get "subject-relationship" => "requests#show"
  get "solicitor-details" => "requests#show"
  get "requester-details" => "requests#show"
  get "letter-of-consent" => "requests#show"
  get "letter-of-consent-check" => "requests#show"
  get "requester-id" => "requests#show"
  get "requester-id-check" => "requests#show"
  get "subject-id" => "requests#show"
  get "subject-id-check" => "requests#show"

  get "moj" => "requests#show"
  get "prison-location" => "requests#show"
  get "prison-number" => "requests#show"
  get "prison-information" => "requests#show"
  get "prison-dates" => "requests#show"

  get "probation-location" => "requests#show"
  get "probation-information" => "requests#show"
  get "probation-dates" => "requests#show"

  get "laa" => "requests#show"
  get "laa-dates" => "requests#show"
  get "opg" => "requests#show"
  get "opg-dates" => "requests#show"
  get "other" => "requests#show"
  get "other-dates" => "requests#show"

  root to: "pages#homepage"

  if Rails.env.test?
    namespace :test do
      resource :session, only: %i[create]
    end
  end
end
