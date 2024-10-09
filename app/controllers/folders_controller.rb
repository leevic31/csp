class FoldersController < ApplicationController
    before_action :authenticate_user!

    def index
        @folders = current_user.folders
    end
  
    def new
        @folder = Folder.new
    end
  
    def create
        @folder = current_user.folders.build(folder_params)

        if @folder.save
            log_audit_action('create', 'Folder', @folder.id)
            redirect_to folders_path, notice: "Folder created successfully."
        else
            render :new
        end
    end
  
    def show
        @folder = Folder.find(params[:id])
        @file_uploads = @folder.file_uploads
    end

    def update
        @folder = current_user.folders.find(params[:id])
        if @folder.update(folder_params)
            redirect_to folder_path(@folder), notice: "Folder updated successfully."
        else
            render :edit
        end
    end
  
    private
  
    def folder_params
        params.require(:folder).permit(:name, :permission)
    end
end
