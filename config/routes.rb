ShoutrouletteV2::Application.routes.draw do

  # these routes need tons of work. but later

  root to: "shouts#index"
  get 'room/:id/:position' => "rooms#show", as: 'show_room'

  scope 'pages', controller: 'pages' do
    get :about, :get_angry, :press
  end

  get 'bunnies' => "admin#index", as: 'admin'
  delete 'topic/:id/remove' => "admin#remove_topic", as: 'remove_topic'
  delete "session/:id/remove" => "admin#remove_session", as: 'remove_session'
  delete 'session/remove' => 'admin#remove_all_sessions', as: 'remove_all_sessions'
  delete 'session/remove_old' => 'admin#remove_all_old_sessions', as: 'remove_all_old_sessions'
  post 'close' => "rooms#close"
  post 'find' => "rooms#find_room"
  post 'topics/new' => "topics#new", as: 'new_topic'

end
