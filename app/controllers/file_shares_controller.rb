class FileSharesController < ApplicationController
    before_action :authenticate_user!

    def create
        if current_user.user?
            @file_share = FileShare.new(file_share_params)
            @file_share.user = current_user
        
            if @file_share.save
              redirect_to file_shares_path, notice: "File shared successfully."
            else
              render :new
            end
        else
            redirect_to file_shares_path, alert: "Not authorized to share the file"
        end
    end
  
    private
  
    def file_share_params
        params.require(:file_share).permit(:file_upload_id, :user_id)
    end
end
