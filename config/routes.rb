Cms::Engine.routes.draw do
  devise_for :cms_user,
             :class_name => "Cms::User",
             :path => 'users',
             :controllers => { :sessions => "cms/sessions" },
             :skip => [:passwords],
             :path_names => { :sign_out => 'logout', :sign_in => 'login' }

  namespace :admin do
    resources :users
  end

  root :to => 'pages#index'
end
