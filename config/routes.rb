Rails.application.routes.draw do
  get '/messages/:recipient', to: 'messages#show'
  post '/messages', to: 'messages#create'
  get '/chat', to: 'chat#show'
end
