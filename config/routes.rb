Rails.application.routes.draw do
  get "homes/index"
  root "homes#index"

  # reload 対策
  get "sign_up", to: "homes#index"
  get "sign_in", to: "homes#index"
  get "articles/new", to: "homes#index"
  get "articles/:id/edit", to: "homes#index"
  get "articles/:id", to: "homes#index"
  get "mypage", to: "homes#index"

  namespace "api", format: "json" do
    namespace "v1" do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }
      namespace "articles" do
        resources :drafts, only: [:index, :show]
      end
      namespace "current" do
        resources :articles, only: [:index]
      end
      resources :articles
    end
  end
end
