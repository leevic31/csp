class Folder < ApplicationRecord
  belongs_to :user

  has_many :file_uploads, dependent: :destroy

  validates :name, presence: true
end
