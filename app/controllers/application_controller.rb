class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    
    before_action :authenticate_user!
    before_action :track_failed_login_attempts, if: :devise_controller?

    MAX_FAILED_LOGIN_ATTEMPTS = 3

    def log_audit_action(action, target_type, target_id)
      AuditLog.create!(
        action: action,
        user_id: current_user.id,
        target_type: target_type,
        target_id: target_id
      )
    end

    protected

    def after_sign_in_path_for(resource)
      resource.reset_failed_login_attempts
      super(resource)
    end
  
    private

    def track_failed_login_attempts
        return unless params[:controller] == 'devise/sessions' && params[:action] == 'create'
        user = User.find_by(email: params[:user][:email])

        if user && user.failed_login_attempts.present?
            user.increment_failed_login_attempts
            log_failed_login_attempt(user) if user.failed_login_attempts >= MAX_FAILED_LOGIN_ATTEMPTS
        end
    end

    def log_failed_login_attempt(user)
        Notification.create(
            message: "Multiple failed login attempts detected for user #{user.email}."
        )
    end
end
