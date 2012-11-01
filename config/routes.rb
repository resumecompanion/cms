Cms::Engine.routes.draw do
  devise_for :users, :class_name => "Cms::User"

  root :to => 'pages#index'
end
