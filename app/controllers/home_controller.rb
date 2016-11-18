class HomeController < ApplicationController
  def index
    if user_signed_in?
      @being_shared_folders = current_user.shared_folders_by_others
      @folders = current_user.folders.roots
      @uploads_label = current_user.uploads.map(&:label).uniq
      @uploads = current_user.uploads.where("folder_id is NULL").order("uploaded_file_file_name desc")
    end
  end

  def browse
    @current_folder = current_user.folders.find_by_id(params[:folder_id])
    @is_this_folder_being_shared = false if @current_folder
    @uploads_label = current_user.uploads.map(&:label).uniq
    if @current_folder.nil?
      folder = Folder.find_by_id(params[:folder_id])

      @current_folder ||= folder if current_user.has_share_access?(folder)
      @is_this_folder_being_shared = true if @current_folder

    end
    if @current_folder
      @being_shared_folders = []
      @folders = @current_folder.children
      @uploads = current_user.uploads.where("folder_id = #{@current_folder.id}").order("uploaded_file_file_name desc")
      render :action => "index"
    else
      flash[:error] = "Don't be cheeky! Mind your own folders!"
      redirect_to root_url
    end
   end



def share
    email_addresses = params[:email_addresses].split(",")

    email_addresses.each do |email_address|
      @shared_folder = current_user.shared_folders.new
      @shared_folder.folder_id = params[:folder_id]
      @shared_folder.shared_email = email_address
      shared_user = User.find_by_email(email_address)
      @shared_folder.shared_user_id = shared_user.id if shared_user
      @shared_folder.message = params[:message]
      @shared_folder.save
      UserMailer.invitation_to_share(@shared_folder).deliver
    end
    respond_to do |format|
      format.js {
      }
    end
end

def activity_data
  from_date = Date.today - 7
  uploads_id = (current_user.uploads.where("created_at >= ?", from_date)).map &(:id)
  @upload_audited_data1 = Audited.audit_class.where("associated_id  IN ('#{uploads_id.join("','")}') AND associated_type = 'Upload' AND auditable_type = 'Comment'")
  @upload_audited_data2 = current_user.associated_audits.where("created_at >= ?", from_date)
end

end
