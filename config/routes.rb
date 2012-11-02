Cms::Engine.routes.draw do
  devise_for :cms_user,
             :class_name => "Cms::User",
             :path => 'users',
             :controllers => { :sessions => "cms/sessions" },
             :skip => [:passwords],
             :path_names => { :sign_out => 'logout', :sign_in => 'login' }

  root :to => 'pages#index'
end
