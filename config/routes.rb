Rails.application.routes.draw do
  devise_for :guests
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  # Grape API
  mount HotelzzAPI::Root => '/'

  root to: 'admin/dashboard#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
