Rails.application.routes.draw do
  get 'map/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # TODO: Use scopes so that we not bloat our routes.
  resources :trips do
    resources :participants
    resources :map
    resources :equipment_lists do
        resources :equipment_items do
            resources :equipment_assignments
        end
    end
    resources :events

    resources :media, only: [:index, :show, :destroy]
  end

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users, only: [:show, :edit, :update] do
    resources :friendships
  end



  get '/dashboard', to: 'dashboard#index', as: 'dashboard'

  get 'search', to: 'trips#search', as: 'search'
  get 'user_search', to: 'users#search', as: 'user_search'

  # Dropbox
  get '/dropbox-connect/:trip_id/:user_id', to: 'media_dropbox#auth_start', as: 'dropbox_connect'
  get '/dropbox-finish', to: 'media_dropbox#auth_finish', as: 'dropbox_finish'

end
