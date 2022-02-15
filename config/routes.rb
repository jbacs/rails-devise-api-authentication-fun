Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }, defaults: { format: :json }

  get '/member-data', to: 'members#show'
end
