class EditaccountsController < ApplicationController
  before_action :authenticate_user!

  def update
    @user = User.find(current_user.id)
    respond_to do |format|
      if @user.update(account_params)
        redirect_to dashboard_path
      else
        redirect_to dashboard_path
      end
    end
  end

  private

  def account_params
    params.permit(:first_name, :last_name, :email, :password)
  end
end