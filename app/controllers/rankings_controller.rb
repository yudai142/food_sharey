class RankingsController < ApplicationController
  include Pagy::Backend
  
  def index
    require "date"
    if params[:time].present?
      @time = params[:time]
    else
      @date = Time.now
      if (Time.parse("03:00")..Time.parse("10:59")).cover? @date
        redirect_to rankings_path(time: "朝食")
        return
      elsif (Time.parse("11:00")..Time.parse("14:59")).cover? @date
        redirect_to rankings_path(time: "昼食")
        return
      elsif (Time.parse("15:00")..Time.parse("16:59")).cover? @date
        redirect_to rankings_path(time: "間食")
        return
      elsif (Time.parse("17:00")..Time.parse("23:59")).cover? @date
        redirect_to rankings_path(time: "夕食")
        return
      elsif (Time.parse("00:00")..Time.parse("02:59")).cover? @date
        redirect_to rankings_path(time: "夜食")
        return
      end
      redirect_to rankings_path(time: "朝食")
      return
    end
    # if (Time.parse("03:00")..Time.parse("09:59")).cover? @date
    #   @ranking = Eatdate.where(timezone: 1).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    #   @menu = "朝食"
    # elsif (Time.parse("10:00")..Time.parse("14:59")).cover? @date
    #   @ranking = Eatdate.where(timezone: 2).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    #   @menu = "昼食"
    # elsif (Time.parse("15:00")..Time.parse("23:59")).cover? @date or (Time.parse("00:00")..Time.parse("02:59")).cover? @date
    #   @ranking = Eatdate.where(timezone: 4).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    #   @menu = "夕食"
    # end
    
    @ranking = Eatdate.where(timezone: @time).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    @arr = Array.new
    @ranking.each do |ranking|
      if Food.find_by(eatdate_id: ranking)
        @arr.push(ranking)
      end
    end
    @pagy, @eatdate = pagy_array(@arr)
    @menu = "人気の#{@time}"
    
  end
end
