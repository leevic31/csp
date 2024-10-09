class FileUpload < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  has_many :file_shares
  belongs_to :folder, optional: false
  
  validates :permission, inclusion: { in: %w[read-only read-write] }
end
