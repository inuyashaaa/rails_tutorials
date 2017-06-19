class Micropost < ApplicationRecord
  belongs_to :user

  scope :create_at_desc, ->{order created_at: :desc}
  scope :user_id, ->id{where "user_id = ?", id}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.microposts.maximum_content_length}
  validate :picture_size

  private

  def picture_size
    if picture.size > (Settings.microposts.max_picture_size).megabytes
      errors.add :picture, t(".max_picture_size")
    end
  end
end
