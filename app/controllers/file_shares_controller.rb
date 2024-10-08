class FileSharesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_file_upload, only: [:new, :create]

    def new
        @file_share = FileShare.new
    end

    def create
        if current_user.user?
            @file_share = FileShare.new(file_share_params)
            @file_share.permission = 'read-only'
        
            if @file_share.save
              redirect_to folder_file_uploads_path(@file_upload.folder), notice: "File shared successfully."
            else
              render :new
            end
        else
            redirect_to folder_file_uploads_path(@file_upload.folder), alert: "Not authorized to share this file."
        end
    end
  
    private
  
    def file_share_params
        params.require(:file_share).permit(:file_upload_id, :user_id)
    end

    def set_file_upload
        @file_upload = FileUpload.find(params[:file_upload_id])
    end
end
