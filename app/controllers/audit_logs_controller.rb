class AuditLogsController < ApplicationController
    before_action :authorize_admin!
  
    def index
        @audit_logs = AuditLog.order(created_at: :desc)
    end
  
    private
  
    def authorize_admin!
        redirect_to root_path, alert: "Not authorized" unless current_user.admin?
    end
end
  