Rails.application.routes.draw do

 resources :folders
 resources :uploads
 devise_for :users
 root :to => "home#index"
 match "uploads/get/:id" => "uploads#get", :as => "download", via: [:get]
 match "browse/:folder_id" => "home#browse", :as => "browse", via: [:get, :post]
 match "browse/:folder_id/new_folder" => "folders#new", :as => "new_sub_folder" , via: [:get,:post]
 match "browse/:folder_id/new_file" => "uploads#new", :as => "new_sub_file" , via: [:get,:post]
 match "browse/:folder_id/rename" => "folders#edit", :as => "rename_folder", via: [:get,:post]
 match "home/share" => "home#share", via: [:get,:post]
 match ":browse/:id/share/delete" => "uploads#bulk_delete", via: [:get,:post]
 match ":browse/home/label_search" => "uploads#label_search", via: [:get,:post]
 match "/home/label_search" => "uploads#label_search", via: [:get,:post]
 match "home/activity_data" => "home#activity_data",:as => "activity", via: [:get,:post]
 # match "/home/activity_data" => "home#activity_data",:as => "activity", via: [:get,:post]

 resources :uploads do
    resources :comments
  end

  resources 'surveys'
  resources 'attempts'
  delete 'attempts/:survey_id/:user_id' => 'attempts#delete_user_attempts', as: :delete_user_attempts
  post 'user/:id/change_name' => 'users#change_name', as: :change_user_name

  
  resources :comments do
    resources :comments
  end
end
