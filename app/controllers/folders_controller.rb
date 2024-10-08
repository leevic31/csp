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
            redirect_to folder_file_uploads_path, notice: "Folder created successfully."
        else
            render :new
        end
    end
  
    def show
        @folder = Folder.find(params[:id])
        @file_uploads = @folder.file_uploads
    end
  
    private
  
    def folder_params
        params.require(:folder).permit(:name)
    end
end
