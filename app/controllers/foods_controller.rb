class FoodsController < ApplicationController
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
    if logged_in?
      @morning_id = Eatdate.find_by(date: @date,timezone: 1 , user_id: current_user.id)
      @lunch_id = Eatdate.find_by(date: @date,timezone: 2 , user_id: current_user.id)
      @dinner_id = Eatdate.find_by(date: @date,timezone: 4 , user_id: current_user.id)
      @morning_foods = Food.where(eatdate_id: @morning_id)
      @lunch_foods = Food.where(eatdate_id: @lunch_id)
      @dinner_foods = Food.where(eatdate_id: @dinner_id)
    end
  end

  def new
    if params[:date].present? && params[:time].present?
      @date = Time.parse(params[:date])
    else
      @date = Time.now
      if (Time.parse("03:00")..Time.parse("10:59")).cover? @date
        redirect_to new_food_path(date: @date.strftime("%Y-%m-%d"), time: "朝食")
        return
      elsif (Time.parse("11:00")..Time.parse("14:59")).cover? @date
        redirect_to new_food_path(date: @date.strftime("%Y-%m-%d"), time: "昼食")
        return
      elsif (Time.parse("15:00")..Time.parse("16:59")).cover? @date
        redirect_to new_food_path(date: @date.strftime("%Y-%m-%d"), time: "間食")
        return
      elsif (Time.parse("17:00")..Time.parse("23:59")).cover? @date
        redirect_to new_food_path(date: @date.strftime("%Y-%m-%d"), time: "夕食")
        return
      elsif (Time.parse("00:00")..Time.parse("02:59")).cover? @date
        redirect_to new_food_path(date: @date.strftime("%Y-%m-%d"), time: "夜食")
        return
      end
      redirect_to new_food_path(date: @date.strftime("%Y-%m-%d"), time: "朝食")
      return
    end
    @mymenu = Mymenu.where(user_id: current_user.id).order("id ASC")
    @eatdate = Eatdate.find_by(date: @date,timezone: params[:time] , user_id: current_user.id)
    @morning_id = Eatdate.find_by(date: @date,timezone: 1 , user_id: current_user.id)
    @lunch_id = Eatdate.find_by(date: @date,timezone: 2 , user_id: current_user.id)
    @snack_id = Eatdate.find_by(date: @date,timezone: 3 , user_id: current_user.id)
    @dinner_id = Eatdate.find_by(date: @date,timezone: 4 , user_id: current_user.id)
    @supper_id = Eatdate.find_by(date: @date,timezone: 5 , user_id: current_user.id)
    @morning_foods = Food.where(eatdate_id: @morning_id)
    @morning_calorie = @morning_foods.sum(:calorie)
    @lunch_foods = Food.where(eatdate_id: @lunch_id)
    @lunch_calorie = @lunch_foods.sum(:calorie)
    @snack_foods = Food.where(eatdate_id: @snack_id)
    @snack_calorie = @snack_foods.sum(:calorie)
    @dinner_foods = Food.where(eatdate_id: @dinner_id)
    @dinner_calorie = @dinner_foods.sum(:calorie)
    @supper_foods = Food.where(eatdate_id: @supper_id)
    @supper_calorie = @supper_foods.sum(:calorie)
  end

  def create
    params[:timezone] = params[:eatdate][:timezone]
    @eatdate = Eatdate.find_by(date: params[:date], timezone: params[:timezone], user_id: current_user.id)
    @eatdate.present? ? @eatdate.update(eat_time: params[:eat_time],comment: params[:comment]) : @eatdate = Eatdate.create!(eatdate_params)
    if params[:mymenu_id].present? && @food = Food.find_by(eatdate_id: @eatdate.id, mymenu_id: params[:mymenu_id])
      @food.delete
    elsif params[:mymenu_id].present?
      @mymenu = Mymenu.find(params[:mymenu_id])
      Food.create!(name: @mymenu.name, image: @mymenu.image.url, calorie: @mymenu.calorie, protein: @mymenu.protein, fat: @mymenu.fat, carbohydrate: @mymenu.carbohydrate, sugar: @mymenu.sugar, dietary_fiber: @mymenu.dietary_fiber, salt: @mymenu.salt, Vitamin_A: @mymenu.Vitamin_A, Vitamin_D: @mymenu.Vitamin_D, Vitamin_E: @mymenu.Vitamin_E, Vitamin_B1: @mymenu.Vitamin_B1, Vitamin_B2: @mymenu.Vitamin_B2, Vitamin_B6: @mymenu.Vitamin_B6, Vitamin_B12: @mymenu.Vitamin_B12, Vitamin_C: @mymenu.Vitamin_C, potassium: @mymenu.potassium, calcium: @mymenu.calcium, magnesium: @mymenu.magnesium, iron: @mymenu.iron, eatdate_id: @eatdate.id, mymenu_id: @mymenu.id)
    end
    redirect_to new_food_path(date: params[:date], time: params[:timezone])
    return
  end

  def edit
  end

  def update
  end

  def destroy
    if params[:id].present?
      @food = Food.find(params[:id]).delete
    end
    redirect_to new_food_path(date: params[:date], time: params[:time])
  end

  private
  def eatdate_params
    params.permit(:date, :timezone, :eat_time, :comment).merge(user_id: current_user.id)
  end

  def food_params
    params.permit(:name, :image, :calorie, :protein, :fat, :carbohydrate, :sugar, :dietary_fiber, :salt, :Vitamin_A, :Vitamin_D, :Vitamin_E, :Vitamin_B1, :Vitamin_B2, :Vitamin_B6, :Vitamin_B12, :Vitamin_C, :potassium, :calcium, :magnesium, :iron, :eatdate_id)
  end
end
