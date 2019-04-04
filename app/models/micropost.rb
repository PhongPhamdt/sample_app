class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true,
  length: {maximum: Settings.maximum_content}
  validate :picture_size

  scope :sort_by_created, ->{order created_at: :desc}

  scope(:feed, lambda do |user|
    where(select("followed_id")
      .from("relationships")
      .where("followed_id = ? ", user).include?(:user_id))
      .or(where(user_id: user))
  end)

  mount_uploader :picture, PictureUploader

  private
  def picture_size
    errors.add :picture, t(".warning") if picture.size > 5.megabytes
  end
end
