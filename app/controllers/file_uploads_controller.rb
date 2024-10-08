class FileUploadsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_file_upload, only: [:destroy, :download, :update, :show]
  
    def index
        @folder = Folder.find(params[:folder_id])
        @file_uploads = if current_user.admin?
                            FileUpload.all
                        elsif current_user.user?
                            current_user.file_uploads + current_user.file_shares.includes(:file_upload).map(&:file_upload)
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
            redirect_to file_uploads_path, notice: "File deleted successfully."
        else
            redirect_to file_uploads_path, alert: "Not authorized to delete this file"
        end
    end

    def download
        if @file_upload.user == current_user || @file_upload.file_shares.exists?(user: current_user)
            send_data @file_upload.file.download, filename: @file_upload.name, disposition: 'attachment'
        else
            redirect_to file_uploads_path, alert: "You are not authorized to download this file."
        end
    end

    def update        
        if @file_upload.user == current_user && @file_upload.update(file_upload_params)
            redirect_to folder_file_upload_path(@file_upload.folder, @file_upload), notice: "File updated successfully."        else
            render :show
        end
    end

    def show
        @file_upload
    end
  
    private
  
    def set_file_upload
      @file_upload = current_user.file_uploads.find(params[:id])
    end
  
    def file_upload_params
      params.require(:file_upload).permit(:file, :name, :permission, :folder_id)
    end
end
