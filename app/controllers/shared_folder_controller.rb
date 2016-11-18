class SharedFolderController < ApplicationController
  before_action :authenticate_user!
  before_action :set_upload, only: [:show, :edit, :update, :destroy, :get]

  private
  def shared_folder_param
    params.require(:shared_folder).permit(:user_id, :shared_email, :shared_user_id,  :message,  :folder_id)
  end
end
