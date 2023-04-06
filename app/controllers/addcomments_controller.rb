class AddcommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @addcomment = Addcomment.new(addcomment_params)

    respond_to do |format|
      if @addcomment.save
        format.html { redirect_to view_addcards_path, notice: "Addcomment was successfully created." }
        format.json { render :show, status: :created, location: @addcard }
      end
    end
  end

  def update
    @addcomment = Addcomment.find(params[:comment_id])
    respond_to do |format|
      if @addcomment.update(addcomment_params)
        format.html { redirect_to view_addcards_path, notice: "Addcomment was successfully updated." }
        format.json { render :show, status: :ok, location: @addcard }
      end
    end
  end

  def destroy
    @deletecomment = Addcomment.find(params[:comment_id])
    @deletecomment.destroy

    respond_to do |format|
      format.html { redirect_to view_addcards_path, notice: "Addcomment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def addcomment_params
      params.require(:addcomment).permit(:comment, :addcard_id, :user_name)
    end


end