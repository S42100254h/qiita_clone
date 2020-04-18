Rails.application.routes.draw do
  get "homes/index"
  root "homes#index"

  # reload 対策
  get "sign_up", to: "homes#index"
  get "sign_in", to: "homes#index"
  get "articles/new", to: "homes#index"

  namespace "api", format: "json" do
    namespace "v1" do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }
      resources :articles
    end
  end
end
