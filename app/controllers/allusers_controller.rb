class AllusersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.email == "jpbocatija@cem-inc.org.ph"
      @all_users = User.all.order("created_at asc")
    end

    User.all.each do |user|
      if user.admin == true
        @all_users = User.all.order("created_at asc")
      end
    end

  end

  def update
    respond_to do |format|
      @role = User.find(params[:id])
      if @role.update(host:params[:host],scribe:params[:scribe])
        format.html { redirect_to view_allusers_path, notice: "Role was successfully updated." }
      end
    end
  end

  def updateadmin
    respond_to do |format|
      @admin = User.find(params[:id])
      if @admin.update(admin: params[:admin])
        format.html { redirect_to view_allusers_path, notice: "Admin was successfully updated." }
      end
    end
  end

end
