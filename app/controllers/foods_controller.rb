class FoodsController < ApplicationController
  def new
    @mymenu = Mymenu.where(user_id: current_user.id).order("id ASC")
  end

  def mymenu_new
    if request.post?
      @mymenu = Mymenu.new(mymenu_params)
      @mymenu = Mymenu.create!(mymenu_params)
      redirect_to new_food_path
    else
      @mymenu = Mymenu.new
    end
  end

  def create
    @eatdate = Eatdate.where(date: params[:date], timezone: params[:timezone], user_id: current_user.id)
    @eatdate.present? ? @eatdate.update(eat_time: params[:eat_time],comment: params[:comment]) : Eatdate.create!(eatdate_params)
    @mymenu = Mymenu.find(params[:mymenu_id])
    @food = Food.create!(name: @mymenu.name, image: @mymenu.image, calorie: @mymenu.calorie, protein: @mymenu.protein, fat: @mymenu.fat, carbohydrate: @mymenu.carbohydrate, sugar: @mymenu.sugar, dietary_fiber: @mymenu.dietary_fiber, salt: @mymenu.salt, Vitamin_A: @mymenu.Vitamin_A, Vitamin_D: @mymenu.Vitamin_D, Vitamin_E: @mymenu.Vitamin_E, Vitamin_B1: @mymenu.Vitamin_B1, Vitamin_B2: @mymenu.Vitamin_B2, Vitamin_B6: @mymenu.Vitamin_B6, Vitamin_B12: @mymenu.Vitamin_B12, Vitamin_C: @mymenu.Vitamin_C, potassium: @mymenu.potassium, calcium: @mymenu.calcium, magnesium: @mymenu.magnesium, iron: @mymenu.iron, eatdate_id: params[:mymenu_id])
    redirect_to new_food_path 
    return
  end

  private

  def mymenu_params
    params.permit(:name, :image, :category_id, :calorie, :protein, :fat, :carbohydrate, :sugar, :dietary_fiber, :salt, :Vitamin_A, :Vitamin_D, :Vitamin_E, :Vitamin_B1, :Vitamin_B2, :Vitamin_B6, :Vitamin_B12, :Vitamin_C, :potassium, :calcium, :magnesium, :iron, :memo).merge(user_id: current_user.id)
  end

  def eatdate_params
    params.permit(:date, :timezone, :eat_time, :comment).merge(user_id: current_user.id)
  end

  def food_params
    params.permit(:name, :image, :calorie, :protein, :fat, :carbohydrate, :sugar, :dietary_fiber, :salt, :Vitamin_A, :Vitamin_D, :Vitamin_E, :Vitamin_B1, :Vitamin_B2, :Vitamin_B6, :Vitamin_B12, :Vitamin_C, :potassium, :calcium, :magnesium, :iron, :eatdate_id)
  end
end
