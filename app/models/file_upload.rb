class FileUpload < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  validates :permission, inclusion: { in: %w[read-only read-write] }
end
