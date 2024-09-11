Rails.application.routes.draw do
  root "cpf#index"
  resources :cpf, only: [:new, :create, :show]
end
