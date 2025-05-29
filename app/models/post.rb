class Post < ApplicationRecord
  belongs_to :user

  validates :title, :content, presence: true
  validates :tags, presence: true
  validate :must_have_at_least_one_tag

  after_create :enqueue_post_job

  private

  def must_have_at_least_one_tag
    errors.add(:tags, "must have at least one tag") if tags.blank? || tags.empty?
  end

  def enqueue_post_job
    PostJob.perform_async(id)
  end
end
