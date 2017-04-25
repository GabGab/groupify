Rails.application.routes.draw do

  root "pages#home"

  match "/webhook", to: "pages#webhook", via: [:get, :post]

  resources :playlists, only: [ :new, :create, :edit, :update ]
end