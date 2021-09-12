class FoodsController < ApplicationController
  def index
    require "date"
    @date = Date.today
    if logged_in?
      @morning_id = Eatdate.find_by(date: @date,timezone: 1 , user_id: current_user.id)
      @lunch_id = Eatdate.find_by(date: @date,timezone: 3 , user_id: current_user.id)
      @dinner_id = Eatdate.find_by(date: @date,timezone: 5 , user_id: current_user.id)
      @morning_foods = Food.where(eatdate_id: @morning_id)
      @lunch_foods = Food.where(eatdate_id: @lunch_id)
      @dinner_foods = Food.where(eatdate_id: @dinner_id)
    end
    @eatdate = Eatdate.joins(:users).where(date: @date.prev_day(7)..@date).group(:id)
    @eatdate
  end

  def new
    if params[:date].present?
      @date = params[:date]
    else
      require "date"
      @date = Date.today
    end
    @mymenu = Mymenu.where(user_id: current_user.id).order("id ASC")
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
