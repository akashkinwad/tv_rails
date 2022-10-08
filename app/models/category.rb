class Category < ApplicationRecord
  validates :name, presence: true
  validates :thumbnail_url, presence: true, on: :update
end
