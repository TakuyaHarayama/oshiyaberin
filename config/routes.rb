Rails.application.routes.draw do
  # get 'threads/index'
  resources :threads, :only => [:ajax_list] do
    collection do
      get 'ajax_list'
      post 'ajax_post'
    end
  end
  root 'threads#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
