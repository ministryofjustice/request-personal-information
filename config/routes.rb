Rails.application.routes.draw do
  get "ping", to: "ping#index"
  get "up" => "rails/health#show", as: :rails_health_check

  get "cookies/:consent" => "cookies#update"

  resource :request, only: %i[new update create] do
    get "/back", to: "requests#back"
  end

  get "subject" => "requests#edit"
  get "subject-name" => "requests#edit"
  get "subject-date-of-birth" => "requests#edit"
  get "subject-relationship" => "requests#edit"
  get "solicitor-details" => "requests#edit"
  get "requester-details" => "requests#edit"
  get "letter-of-consent" => "requests#edit"
  get "letter-of-consent-check" => "requests#edit"
  get "requester-id" => "requests#edit"
  get "requester-address" => "requests#edit"
  get "requester-id-check" => "requests#edit"
  get "subject-id" => "requests#edit"
  get "subject-address" => "requests#edit"
  get "subject-id-check" => "requests#edit"

  get "moj" => "requests#edit"
  get "prison-location" => "requests#edit"
  get "prison-number" => "requests#edit"
  get "prison-information" => "requests#edit"
  get "prison-dates" => "requests#edit"

  get "probation-location" => "requests#edit"
  get "probation-information" => "requests#edit"
  get "probation-dates" => "requests#edit"

  get "laa" => "requests#edit"
  get "laa-dates" => "requests#edit"
  get "opg" => "requests#edit"
  get "opg-dates" => "requests#edit"
  get "other-where" => "requests#edit"
  get "other" => "requests#edit"
  get "other-dates" => "requests#edit"

  get "contact-address" => "requests#edit"
  get "contact-email" => "requests#edit"
  get "upcoming" => "requests#edit"

  get "check-answers" => "requests#show"
  get "form-sent" => "requests#complete"

  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unprocessable_entity"
  get "/500", to: "errors#internal_error"

  root to: "pages#homepage"

  if Rails.env.test?
    namespace :test do
      resource :session, only: %i[create]
    end
  end
end
