Rails.application.routes.draw do
  get "ping", to: "ping#index"
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "pages#homepage"
end
