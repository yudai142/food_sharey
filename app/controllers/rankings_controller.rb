class RankingsController < ApplicationController
  def index
    require "date"
    @date = Time.now
    if (Time.parse("03:00")..Time.parse("09:59")).cover? @date
      @ranking = Eatdate.where(timezone: 1).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
      @menu = "朝食"
    elsif (Time.parse("10:00")..Time.parse("14:59")).cover? @date
      @ranking = Eatdate.where(timezone: 2).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
      @menu = "昼食"
    elsif (Time.parse("15:00")..Time.parse("23:59")).cover? @date or (Time.parse("00:00")..Time.parse("02:59")).cover? @date
      @ranking = Eatdate.where(timezone: 4).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
      @menu = "夕食"
    end
    @arr = Array.new
    @ranking.each do |ranking|
      if Food.find_by(eatdate_id: ranking)
        @arr.push(
          user: User.find(ranking.user_id).name, 
          image: Food.where(eatdate_id: ranking).limit(5).pluck(:image),
          calorie: Food.where(eatdate_id: ranking).sum(:calorie),
          eatdate_id: ranking.id,
          good_count: EatdateLike.where(eatdate_id: ranking.id)
        )
      end
      break if @arr.length == 10
    end
  end
end
