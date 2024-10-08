class NotificationsController < ApplicationController
    before_action :authenticate_admin!
  
    def index
        @notifications = Notification.all
    end
  
    private
  
    def authenticate_admin!
        redirect_to root_path, alert: "Access denied." unless current_user&.admin?
    end
end