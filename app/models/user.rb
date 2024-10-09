class User < ApplicationRecord
  has_many :file_uploads, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :file_shares, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = %w[admin user guest]

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= 'user'
  end

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end

  def guest?
    role == 'guest'
  end

  def increment_failed_login_attempts
    increment!(:failed_login_attempts)
  end

  def reset_failed_login_attempts
    update(failed_login_attempts: 0)
  end
end
