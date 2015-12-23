Rails.application.routes.draw do
  root 'home#index'
  post '/screenshot', to: 'home#screenshot'
end
