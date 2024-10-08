class ApplicationController < ActionController::Base
    before_action :authenticate_user!

    def log_audit_action(action, target_type, target_id)
      AuditLog.create!(
        action: action,
        user_id: current_user.id,
        target_type: target_type,
        target_id: target_id
      )
    end
end
