class Recipe < ApplicationRecord
  validates :title, :cook_time, :difficulty, presence: true
  has_rich_text :content
  belongs_to :user
end
