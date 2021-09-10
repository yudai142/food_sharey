class Eatdate < ApplicationRecord
  has_many :foods
  belongs_to :user

  enum timezone: {"朝食": 1, "朝間食": 2, "昼食": 3, "間食": 4, "夕食": 5, "夜食": 6}
end
