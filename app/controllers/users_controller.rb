class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @folders = @user.folders.includes(:file_uploads)
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: "Not authorized." unless current_user.admin?
  end
end
