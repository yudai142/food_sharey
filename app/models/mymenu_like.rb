class MymenuLike < ApplicationRecord
  belongs_to :mymenu
  belongs_to :user
end
