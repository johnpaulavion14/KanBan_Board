class HomeController < ApplicationController
  def index
  end

  def reset_password
  end

  def update_reset_password
    @user = User.find_by(email: params[:email])
    
    respond_to do |format|
      if @user != nil
        @token = @user.send(:set_reset_password_token)
        @user.update(password_token:@token )
        format.html { redirect_to root_path, notice: "Ask admin for password token to reset password" }
      else
        format.html { redirect_to reset_password_path, alert: "This email is not registered to database" }
      end
    end
  end
end
