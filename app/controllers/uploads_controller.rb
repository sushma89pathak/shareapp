class UploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_upload, only: [:show, :edit, :update, :destroy, :get]
  skip_before_filter :verify_authenticity_token, :only => [:label_search]

  def index
    @uploads = current_user.uploads
  end

  def show
    @upload = current_user.uploads.find(params[:id])
  end

  def label_search
    @uploads = current_user.uploads.where("label IN ('#{params["label_names"].join("','")}') ").order("uploaded_file_file_name desc")
  end

  def bulk_delete
    if params["file_ids"].present?
      params["file_ids"].each do |id|
        (Upload.find_by_id(id)).destroy
      end
    end
    redirect_to root_url
  end


  def new
    @upload = current_user.uploads.build
    if params[:folder_id]
      @current_folder = current_user.folders.find(params[:folder_id])
      @upload.folder_id = @current_folder.id
    end
  end

  # GET /uploads/1/edit
  def edit
    @upload = current_user.uploads.find(params[:id])
  end


  def get
    upload = current_user.uploads.find_by_id(params[:id])
    upload ||= Upload.find(params[:id]) if current_user.has_share_access?(Upload.find_by_id(params[:id]).folder)
    if upload
      #Parse the URL for special characters first before downloading
      # data = open(URI.parse(URI.encode(upload.uploaded_file.url)).to_s)

      #then again, use the "send_data" method to send the above binary "data" as file.
      # send_data data, :filename => upload.uploaded_file_file_name

      #redirect to amazon S3 url which will let the user download the file automatically
      redirect_to upload.uploaded_file.url, :type => upload.uploaded_file_content_type
    else
      flash[:error] = "Unauthorized Access!!"
      redirect_to root_url
    end
  end


  # POST /uploads
  # POST /uploads.json
  def create
    @upload = current_user.uploads.build(upload_params)
    if @upload.save
      flash[:notice] = "Successfully uploaded the file."
      if @upload.folder
        redirect_to browse_path(@upload.folder)
      else
        redirect_to root_url
      end
    else
      render :action => 'new'
    end
  end

  def update
    @upload = current_user.uploads.find(params[:id])
    respond_to do |format|
      if @upload.update(upload_params)
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { render :show, status: :ok, location: @upload }
      else
        format.html { render :edit }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @upload = current_user.uploads.find(params[:id])
    @parent_folder = @upload.folder
    @upload.destroy
    flash[:notice] = "Successfully deleted the file."
    if @parent_folder
     redirect_to browse_path(@parent_folder)
    else
     redirect_to root_url
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_upload
    @upload = Upload.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def upload_params
    params.require(:upload).permit(:uploaded_file, :user_id, :folder_id,:label)
  end
end
