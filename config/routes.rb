Cms::Engine.routes.draw do
  devise_for :cms_user,
             :class_name => "Cms::User",
             :path => 'users',
             :controllers => { :sessions => "cms/sessions" },
             :skip => [:passwords],
             :path_names => { :sign_out => 'logout', :sign_in => 'login' }

  namespace :admin do
    resources :users
    resources :navigations, :except => [:show]
    resources :images
    resources :ckeditor, :only => [:index, :create]
    resources :pages, :except => [:show] do
      get :children, :on => :member
      get :children_selector, :on => :collection
    end
    root :to => 'users#index'
  end

  match "/:id" => "pages#show", :as => :pages

  root :to => 'pages#index'
end
