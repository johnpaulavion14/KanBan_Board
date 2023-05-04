class ApplicationController < ActionController::Base
  before_action :set_page

  def set_page
    if user_signed_in? 
      @name_initial = current_user.first_name.chr + current_user.last_name.chr

      if !current_user.profilepics.blank?
        @profilepic = current_user.profilepics.last
      end
    end
  end

end
