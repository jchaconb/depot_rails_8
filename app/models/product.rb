class Product < ApplicationRecord
  has_one_attached :image

  # This tells Rails to broadcast changes to the product model to any clients that are listening.
  after_commit -> { broadcast_refresh_later_to "products" }
end
