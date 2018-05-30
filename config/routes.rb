Rails.application.routes.draw do
  root :to => 'portal#page'
  DrgCms.routes

  put '/portal/process_login' => 'portal#process_login'

  post '/reports/diary' 
  
  resources :init # remove after initial run
  
  
  get '*path' => 'portal#page'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
