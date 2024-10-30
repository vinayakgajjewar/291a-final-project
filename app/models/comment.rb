class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true
  validate :restrict_influential_content

  private

  def restrict_influential_content
    restricted_keywords = [ "Trump", "Harris" ]
    if restricted_keywords.any? { |word| content&.include?(word) }
      errors.add(:content, "contains restricted content related to election influence.")
    end
  end
end
