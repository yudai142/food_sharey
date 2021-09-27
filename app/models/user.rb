class User < ApplicationRecord
  authenticates_with_sorcery!
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, uniqueness: true, format: {with: VALID_EMAIL_REGEX}, presence: true
  validates :password,length: {minimum: 3},if: -> { new_record? || changes[:crypted_password] }
  validates :password,confirmation: true,if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation,presence: true,if: -> { new_record? || changes[:crypted_password] }

  has_many :eatdates
  has_many :mymenus
end
