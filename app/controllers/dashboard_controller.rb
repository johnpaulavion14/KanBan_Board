class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @create_boards = current_user.create_boards.where(group:false).order("created_at asc")
    @group_boards = CreateBoard.where(group:true).order("created_at asc")

  end
end
