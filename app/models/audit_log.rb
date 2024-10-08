class AuditLog < ApplicationRecord
    belongs_to :user
    validates :action, presence: true
    validates :target_type, presence: true
    validates :target_id, presence: true
end