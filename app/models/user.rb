class User < ApplicationRecord
  has_secure_password

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: "must be a valid email" }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
end
