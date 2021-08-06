class FoodsController < ApplicationController
  def new; end

  def mymenu_new
    if request.post?
      @mymenu = Mymenu.new(mymenu_params)
      @mymenu = Mymenu.create!(mymenu_params)
      redirect_to new_food_path
    else
      @mymenu = Mymenu.new
    end
  end

  private

  def mymenu_params
    params.permit(:name, :image, :category_id, :calorie, :protein, :fat, :carbohydrate, :sugar, :dietary_fiber, :salt, :Vitamin_A, :Vitamin_D, :Vitamin_E, :Vitamin_B1, :Vitamin_B2, :Vitamin_B6, :Vitamin_B12, :Vitamin_C, :potassium, :calcium, :magnesium, :iron, :memo).merge(user_id: current_user.id)
  end
end
