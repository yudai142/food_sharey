class EatdateLikesController < ApplicationController
  def create
    EatdateLike.create!(like_params)
    @eatdate = Eatdate.find(params[:eatdate_id])
  end

  def destroy
    EatdateLike.find_by(eatdate_id: params[:id], user_id: current_user.id).delete
    @eatdate = Eatdate.find(params[:id])
  end

  private


  def like_params
    params.permit(:eatdate_id).merge(user_id: current_user.id)
  end

end
