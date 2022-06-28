class Eatdate < ApplicationRecord
  has_many :foods
  belongs_to :user
  has_many :eatdate_likes
  has_many :liked_users, through: :eatdate_likes, source: :user

  enum timezone: {"朝食": 1, "昼食": 2, "間食": 3, "夕食": 4, "夜食": 5}
end
