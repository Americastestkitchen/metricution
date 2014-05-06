Rails.application.routes.draw do

  root 'frontend#client'

  namespace :api do
    namespace :v1 do

      resources :bathrooms, except: [:new, :edit]

      namespace :events do
        get :bathrooms
      end

    end
  end

end
