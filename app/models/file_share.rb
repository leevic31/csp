class FileShare < ApplicationRecord
  belongs_to :file_upload
  belongs_to :user

  validates :permission, inclusion: { in: %w[read-only read-write] }
end
