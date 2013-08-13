Cms::Engine.routes.draw do
  devise_for :cms_user,
             :class_name => "Cms::User",
             :path => 'users',
             :controllers => { :sessions => "cms/sessions" },
             :skip => [:passwords],
             :path_names => { :sign_out => 'logout', :sign_in => 'login' }

  namespace :admin do
    resources :settings, :only => [:index, :edit, :update]
    resources :users
    resources :navigations, :except => [:show]
    resources :images
    resources :sidebars, :except => [:show, :destroy]
    resources :ckeditor, :only => [:index, :create]
    resources :pages, :except => [:show] do
      get :children, :on => :member
      get :children_selector, :on => :collection
    end
    root :to => 'users#index'
  end

  unless Rails.env.development?
    match "*initial_path", to: redirect {|params, req| req.url.gsub(/^https/, 'http')}, constraints: lambda {|request| puts request.path; request.ssl? && !(request.path =~ /users/ || request.path =! /admin/)}
  end
  match "/search" => "pages#search"
  match "/404" => "pages#render_404"
  match "/:id" => "pages#show", :as => :pages

  root :to => 'pages#index'
end
