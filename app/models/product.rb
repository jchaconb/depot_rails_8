class Product < ApplicationRecord
  has_one_attached :image

  # This tells Rails to broadcast changes to the product
  # model to any clients that are listening.
  after_commit -> { broadcast_refresh_later_to "products" }

  validates :title, :description, :image, presence: true
  validates :title, uniqueness: true
  validates :title, length: { minimum: 10 }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  validate :acceptable_image

  ACCEPTABLE_TYPES = [ "image/gif", "image/jpeg", "image/png" ]

  private

    def acceptable_image
      return unless image.attached?

      unless ACCEPTABLE_TYPES.include?(image.content_type)
        errors.add(:image, "must be a GIF, JPEG or PNG")
      end
    end
end
