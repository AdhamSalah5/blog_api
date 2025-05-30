class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, :body, presence: true
  validates :tags, presence: true
  validate :must_have_valid_tags

  after_create :enqueue_post_job

  private

  def must_have_valid_tags
    if tags.nil? || !tags.is_a?(Array) || tags.empty?
      errors.add(:tags, "must be a non-empty array")
    end
  end

  def enqueue_post_job
     DeletePostJob.perform_in(24.hours, self.id)
  end
end
