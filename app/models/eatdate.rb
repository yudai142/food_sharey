class Eatdate < ApplicationRecord
  has_many :foods
  belongs_to :user
  has_many :eatdate_likes

  enum timezone: {"朝食": 1, "昼食": 2, "間食": 3, "夕食": 4, "夜食": 5}
end
