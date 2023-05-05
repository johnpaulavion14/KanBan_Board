class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @create_boards = current_user.create_boards.where(group:false)
    @group_boards = CreateBoard.where(group:true)

    # if current_user.create_boards.where(id:params[:id]) == []
    #   @private = false
    #   @user = CreateBoard.find_by(id:params[:id]).user.email
    # else
    #   @private = true
    # end
    @all_users = User.all

  end
end
