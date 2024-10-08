class FileSharesController < ApplicationController
    before_action :authenticate_user!

    def create
      @file_share = FileShare.new(file_share_params)
      @file_share.user = current_user
  
      if @file_share.save
        redirect_to file_uploads_path, notice: "File shared successfully."
      else
        redirect_to file_uploads_path, alert: "Failed to share file."
      end
    end
  
    private
  
    def file_share_params
        params.require(:file_share).permit(:file_upload_id, :user_id)
    end
end
