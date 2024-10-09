class FileSharesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_file_upload, only: [:new, :create]
    before_action :set_shared_file, only: [:download]

    def new
        @file_share = FileShare.new
    end

    def create
        if current_user.user?
            @file_share = FileShare.new(file_share_params)
            @file_share.permission = 'read-only'
            @file_share.file.attach(@file_upload.file.blob)
        
            if @file_share.save
                log_audit_action('create', 'FileShare', @file_share.id)
                redirect_to folder_file_uploads_path(@file_upload.folder), notice: "File shared successfully."
            else
                render :new
            end
        else
            redirect_to folder_file_uploads_path(@file_upload.folder), alert: "Not authorized to share this file."
        end
    end

    def download
        if @file_share.file.attached?
            send_data @file_share.file.download, filename: @file_share.file.filename.to_s, disposition: 'attachment'
            log_audit_action('download', "Shared File", @file_share.id)
        else
            redirect_to root_path, alert: "File not found."
        end
    end
  
    private
  
    def file_share_params
        params.require(:file_share).permit(:file_upload_id, :user_id)
    end

    def set_file_upload
        @file_upload = FileUpload.find(params[:file_upload_id])
    end

    def set_shared_file
        @file_share = FileShare.find(params[:id])
    end
end
