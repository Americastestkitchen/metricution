Rails.application.routes.draw do

  root 'frontend#ember'

  namespace :api do
    namespace :v1 do

      resources :bathroom_status, only: [:index, :show, :update]

    end
  end

end
