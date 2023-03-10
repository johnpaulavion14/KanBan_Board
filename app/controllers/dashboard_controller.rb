class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @create_boards = current_user.create_boards.all
  end
  
end
