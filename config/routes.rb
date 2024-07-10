Rails.application.routes.draw do
  get 'chatbot/index'
  root 'chatbot#index'
  post 'ask', to: 'chatbot#ask'
end