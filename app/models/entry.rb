class Entry < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 140 }
  validates :body, presence: true
  validate  :picture_size

  default_scope -> { order(created_at: :desc) }

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
