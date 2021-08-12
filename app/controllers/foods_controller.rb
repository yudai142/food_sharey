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
    binding.pry
    @eatdate = Eatdate.where(date: params(:date), user_id: current_user.id)
    unless @eatdate
    end
    @mymenu = Mymenu.find(params[:mymenu_id])
    @food =Food.create(name: @mymenu.name, )

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
