class EatdateLikesController < ApplicationController
  def create
    EatdateLike.create!(like_params)
    @eatdate_like = EatdateLike.where(eatdate_id: params[:eatdate_id])
  end

  def delete
    EatdateLike.find_by(eatdate_id: params[:eatdate_id], user_id: current_user.id).delete
    @eatdate_like = EatdateLike.where(eatdate_id: params[:eatdate_id])
  end

  private


  def like_params
    params.permit(:eatdate_id).merge(user_id: current_user)
  end

end
