class Category < ApplicationRecord
  validates :name, :thumbnail_url, presence: true
end
