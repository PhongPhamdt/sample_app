class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true

  validates :content, presence: true,
  length: {maximum: Settings.maximum_content}

  validate :picture_size

  scope :sort_by_created, ->{order created_at: :desc}

  mount_uploader :picture, PictureUploader

  private
  def picture_size
    errors.add :picture, t(".warning") if picture.size > 5.megabytes
  end
end
