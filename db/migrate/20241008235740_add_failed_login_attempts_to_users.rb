class AddFailedLoginAttemptsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :failed_login_attempts, :integer, default: 0
  end
end
