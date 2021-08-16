class MymenusController < ApplicationController

  def index
    @mymenu = Mymenu.where(user_id: current_user.id)
  end

  def new
    @mymenu = Mymenu.new
  end

  def create
    Mymenu.create!(mymenu_params)
    redirect_to new_food_path
  end

  def edit
    @mymenu = Mymenu.find(params[:id])
  end

  def update
    @mymenu = Mymenu.find(params[:id])
    @mymenu.update(mymenu_params)
    redirect_to new_food_path
  end

  def destroy
  end

  private

  def mymenu_params
    params.require(:mymenu).permit(:name, :image, :category_id, :calorie, :protein, :fat, :carbohydrate, :sugar, :dietary_fiber, :salt, :Vitamin_A, :Vitamin_D, :Vitamin_E, :Vitamin_B1, :Vitamin_B2, :Vitamin_B6, :Vitamin_B12, :Vitamin_C, :potassium, :calcium, :magnesium, :iron, :memo).merge(user_id: current_user.id)
  end
end