class FoodsController < ApplicationController
  skip_before_action :require_login, only: [:index]
  def index
    require "date"
    @date = Time.now
    current_hour = @date.hour
    
    # Determine meal time based on current hour
    if (3..9).cover?(current_hour)
      @ranking = Eatdate.where(timezone: 1).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
      @menu = "人気の朝食メニュー"
    elsif (10..14).cover?(current_hour)
      @ranking = Eatdate.where(timezone: 2).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
      @menu = "人気の昼食メニュー"
    elsif (15..23).cover?(current_hour) || (0..2).cover?(current_hour)
      @ranking = Eatdate.where(timezone: 4).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
      @menu = "人気の夕食メニュー"
    else
      # Default to evening if time doesn't match any category
      @ranking = Eatdate.where(timezone: 4).includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
      @menu = "人気の夕食メニュー"
    end
    @eatdate = Array.new
    @ranking.each do |ranking|
      if Food.find_by(eatdate_id: ranking.id)
        @eatdate.push(ranking)
      end
      if logged_in?
        break if @eatdate.length == 10
      else
        break if @eatdate.length == 8
      end
    end
    if logged_in?
      @morning_id = Eatdate.find_by(date: @date,timezone: 1 , user_id: current_user.id)
      @lunch_id = Eatdate.find_by(date: @date,timezone: 2 , user_id: current_user.id)
      @dinner_id = Eatdate.find_by(date: @date,timezone: 4 , user_id: current_user.id)
      @morning_foods = @morning_id ? Food.where(eatdate_id: @morning_id.id) : []
      @lunch_foods = @lunch_id ? Food.where(eatdate_id: @lunch_id.id) : []
      @dinner_foods = @dinner_id ? Food.where(eatdate_id: @dinner_id.id) : []
      @tutorial = 'ようこそ！まずは記録ボタンから食事内容を記録しましょう' if !Eatdate.find_by(user_id: current_user.id)
    end
  end

  def new
    if params[:date].present? && params[:time].present?
      @date = Time.parse(params[:date])
      @timezone = params[:time]
    else
      @date = Time.now.to_date
      current_hour = Time.now.hour
      if (3..10).cover?(current_hour)
        @timezone = "朝食"
      elsif (11..14).cover?(current_hour)
        @timezone = "昼食"
      elsif (15..16).cover?(current_hour)
        @timezone = "間食"
      elsif (17..23).cover?(current_hour)
        @timezone = "夕食"
      elsif (0..2).cover?(current_hour)
        @timezone = "夜食"
      end
    end
    @mymenu = Mymenu.where(user_id: current_user.id).order("id ASC")
    @eatdate = Eatdate.find_by(date: @date,timezone: @timezone , user_id: current_user.id)
    @morning_id = Eatdate.find_by(date: @date,timezone: 1 , user_id: current_user.id)
    @lunch_id = Eatdate.find_by(date: @date,timezone: 2 , user_id: current_user.id)
    @snack_id = Eatdate.find_by(date: @date,timezone: 3 , user_id: current_user.id)
    @dinner_id = Eatdate.find_by(date: @date,timezone: 4 , user_id: current_user.id)
    @supper_id = Eatdate.find_by(date: @date,timezone: 5 , user_id: current_user.id)
    @morning_foods = @morning_id ? Food.where(eatdate_id: @morning_id.id) : []
    @morning_calorie = @morning_foods.sum(:calorie)
    @lunch_foods = @lunch_id ? Food.where(eatdate_id: @lunch_id.id) : []
    @lunch_calorie = @lunch_foods.sum(:calorie)
    @snack_foods = @snack_id ? Food.where(eatdate_id: @snack_id.id) : []
    @snack_calorie = @snack_foods.sum(:calorie)
    @dinner_foods = @dinner_id ? Food.where(eatdate_id: @dinner_id.id) : []
    @dinner_calorie = @dinner_foods.sum(:calorie)
    @supper_foods = @supper_id ? Food.where(eatdate_id: @supper_id.id) : []
    @supper_calorie = @supper_foods.sum(:calorie)
    if !Mymenu.find_by(user_id: current_user.id) && !Eatdate.find_by(user_id: current_user.id)
      @tutorial1 = 'まずはMYメニューを作成してメニューを登録しましょう'
    elsif !Eatdate.find_by(user_id: current_user.id)
      @tutorial2 = '登録ができたら上の食事時刻を食事を行った日時に設定し、下の登録したメニューから食事内容を記録しましょう'
    elsif session[:tutorial3]
      @tutorial3 = session[:tutorial3]
      session.delete(:tutorial3)
    end
  end

  def create
    params[:timezone] = params[:eatdate][:timezone]
    @eatdate = Eatdate.find_by(date: params[:date], timezone: params[:timezone], user_id: current_user.id)
    if !Eatdate.find_by(user_id: current_user.id)
      session[:tutorial3] = '下のリストに食事記録が反映されました！食事習慣を続けていきましょう'
    end
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
    @food = Food.find_by_id(params[:id])
    if @food && @food.eatdate.user_id == current_user.id
      @food.delete
      redirect_to new_food_path(date: params[:date], time: params[:time])
    else
      redirect_to root_path
    end
  end

  private
  def eatdate_params
    params.permit(:date, :timezone, :eat_time, :comment).merge(user_id: current_user.id)
  end

  def food_params
    params.permit(:name, :image, :calorie, :protein, :fat, :carbohydrate, :sugar, :dietary_fiber, :salt, :Vitamin_A, :Vitamin_D, :Vitamin_E, :Vitamin_B1, :Vitamin_B2, :Vitamin_B6, :Vitamin_B12, :Vitamin_C, :potassium, :calcium, :magnesium, :iron, :eatdate_id)
  end
end
