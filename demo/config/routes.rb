Dummy::Application.routes.draw do
  resources :users

  root to: "bootstrap#form"
  get "/bootstrap/static_control", to: "bootstrap#static_control"
  # post "admin/users", to: "bootstrap#create", as: "admin_users_path"
  post "/admin/users", to: "bootstrap#create", as: "admin_users"
end
