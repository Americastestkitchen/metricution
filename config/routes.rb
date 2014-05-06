Rails.application.routes.draw do

  root 'frontend#ember'

  namespace :api do
    namespace :v1 do

      resources :bathrooms, only: [:index, :show, :update]

      namespace :events do
        get :bathrooms
      end

    end
  end

end
