class FileUploadsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_file_upload, only: [:destroy, :download, :update, :show]
  
    def index
        @folder = Folder.find(params[:folder_id])
        @file_uploads = if current_user.admin?
                            FileUpload.all
                        elsif current_user.user?
                            current_user.file_uploads
                        elsif current_user.guest?
                            current_user.file_shares.includes(:file_upload).map(&:file_upload)
                        else
                            []
                        end
    end

    def new
        @folder = Folder.find(params[:folder_id])
        @file_upload = @folder.file_uploads.build
    end
  
    def create
        if current_user.user?           
            @folder = Folder.find(params[:folder_id])
            @file_upload = @folder.file_uploads.build(file_upload_params)
            @file_upload.user = current_user

            if @file_upload.save
                log_audit_action('create', 'FileUpload', @file_upload.id)
                redirect_to folder_file_uploads_path(@folder), notice: "File uploaded successfully."
            else
                redirect_to folder_file_uploads_path(@folder), alert: "Unsuccessfully uploaded file"
            end
        else
            redirect_to folder_file_uploads_path(@folder), alert: "Not authorized to upload this file"
        end
    end
  
    def destroy
        if @file_upload.user == current_user 
            @file_upload.destroy
            log_audit_action('destroy', 'FileUpload', @file_upload.id)
            redirect_to file_uploads_path, notice: "File deleted successfully."
        else
            redirect_to file_uploads_path, alert: "Not authorized to delete this file"
        end
    end

    def download
        send_data @file_upload.file.download, filename: @file_upload.name, disposition: 'attachment'
        log_audit_action('download', 'FileUpload', @file_upload.id)
    end

    def update        
        if @file_upload.user == current_user && @file_upload.update(file_upload_params)
            log_audit_action('permission update', 'FileUpload', @file_upload.id)
            redirect_to folder_file_upload_path(@file_upload.folder, @file_upload), notice: "File updated successfully."        
        else
            render :show
        end
    end

    def show
        @file_upload
    end
  
    private
  
    def set_file_upload
      @file_upload = FileUpload.find(params[:id])
    end
  
    def file_upload_params
      params.require(:file_upload).permit(:file, :name, :permission, :folder_id)
    end
end
