Rails.application.routes.draw do

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do

      resources :bathrooms, except: [:new, :edit]

      namespace :events do
        get :bathrooms
      end

    end
  end

  root to:        'frontend#client'
  get  '*path' => 'frontend#client'

end
