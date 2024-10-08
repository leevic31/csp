class FileUpload < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  has_many :file_shares, dependent: :destroy
  
  validates :permission, inclusion: { in: %w[read-only read-write] }
end
