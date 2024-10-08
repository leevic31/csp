class FileUploadsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_file_upload, only: [:destroy, :download]
  
    def index
        if current_user.admin?
            @file_uploads = FileUpload.all
        else
            @file_uploads = current_user.file_uploads
        end
    end
  
    def create
        if current_user.user?
            @file_upload = current_user.file_uploads.new(file_upload_params)

            if @file_upload.save
                redirect_to file_uploads_path, notice: "File uploaded successfully."
            else
                render :index
            end
        else
            redirect_to file_uploads_path, alert: "Not authorized to upload this file"
        end

    end
  
    def destroy
        if current_user.user? && @file_upload.user == current_user 
            @file_upload.destroy
            redirect_to file_uploads_path, notice: "File deleted successfully."
        else
            redirect_to file_uploads_path, alert: "Not authorized to delete this file"
        end
    end

    def download
        if @file_upload.user == current_user
            send_file @file_upload.file.download, filename: @file_upload.name, disposition: 'attachment'
        else
            redirect_to file_uploads_path, alert: "You are not authorized to download this file."
        end
    end
  
    private
  
    def set_file_upload
      @file_upload = current_user.file_uploads.find(params[:id])
    end
  
    def file_upload_params
      params.require(:file_upload).permit(:file, :name)
    end
end
