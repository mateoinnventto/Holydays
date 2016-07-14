Rails.application.routes.draw do
  devise_for :users do 

  end
  resources :users, only: [] do
  	resources :vacations
  end
  get 'home/index'

  root 'home#index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
