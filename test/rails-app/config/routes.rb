Rails.application.routes.draw do
  resource :timeline, only: [], controller: :timeline do
    get :public
    get :home
  end

  resources :statuses, only: [:create, :show, :update]
end
