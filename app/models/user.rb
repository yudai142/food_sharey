class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :password,length: {minimum: 6},if: -> { new_record? || changes[:crypted_password] }
  validates :password,confirmation: true,if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation,presence: true,if: -> { new_record? || changes[:crypted_password] }
  
  validates :name, presence: true, length: {maximum: 20}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false },
                    format: {with: VALID_EMAIL_REGEX, allow_blank: true}
  
  
  
  has_many :eatdates
  has_many :mymenus
  has_many :mymenu_likes
  has_many :eatdate_likes

  def self.guest
    begin
      find_or_create_by!(email: SecureRandom.urlsafe_base64 + '@email.com') do |user|
        user.name = "ゲストユーザー"
        @password = SecureRandom.urlsafe_base64
        user.password = @password
        user.password_confirmation = @password
        user.user_ranking_hide = 1
      end
    # rescue ActiveRecord::RecordNotUnique
    #   find_by(email: 'guestda@example.com')
    end
  end

  def self.guest_new
    create!(
      name: 'ゲスト',
      email: SecureRandom.alphanumeric(10) + "@email.com",
      password: 'password',
      password_confirmation: 'password',
      user_ranking_hide: 1
    )
  end
end
