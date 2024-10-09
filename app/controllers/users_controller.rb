class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_user, only: [:show, :update_role]

  def index
    @users = User.all
  end

  def show
    @folders = @user.folders.includes(:file_uploads)
  end

  def update_role
    if current_user.admin? && @user.update(user_params)
        log_audit_action('user permission update', 'User', @user.id)
        redirect_to user_path(@user), notice: 'User updated successfully.'
    else
      redirect_to user_path, alert: 'Failed to update the user role'
    end
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: "Not authorized." unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role)
  end
end
