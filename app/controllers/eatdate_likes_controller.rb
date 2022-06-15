class EatdateLikesController < ApplicationController
  def create
    EatdateLike.create!(like_params)
    @ranking = {
      eatdate_id: params[:eatdate_id],
      good_count: EatdateLike.where(eatdate_id: params[:eatdate_id])
    }
  end

  def destroy
    EatdateLike.find_by(eatdate_id: params[:id], user_id: current_user.id).delete
    @ranking = {
      eatdate_id: params[:id],
      good_count: EatdateLike.where(eatdate_id: params[:id])
    }
  end

  private


  def like_params
    params.permit(:eatdate_id).merge(user_id: current_user.id)
  end

end
