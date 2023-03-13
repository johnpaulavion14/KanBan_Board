class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @create_boards = current_user.create_boards.where(group:false)
    @group_boards = CreateBoard.where(group:true)
  end

  
end
