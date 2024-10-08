class AddcardsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_card, only: %i[ index edit edit_desc create update destroy attendance update_conclusion generate_mom]
  # before_action :set_addcard, only: %i[ show edit update destroy ]

  # GET /addcards or /addcards.json
  def index
    @board = CreateBoard.find(params[:cb_id])
    @addcard = @card.addcards.find(params[:id])
    @card_name = @addcard.card
    @desc_value = @addcard.desc.to_s.gsub(/\n/, '<br/>').html_safe
    @comments = Addcomment.all.where(addcard_id: params[:id]).order("created_at desc")
    # todo
    @todo_list = @addcard.todos.order("created_at asc")
    # identify
    @identify_list = @addcard.identifies.order("created_at asc")

    @host = HostScribe.where('date <= ?',Date.today) == [] ? "" : HostScribe.where('date <= ?',Date.today).order("date asc").last.host
    @scribe = HostScribe.where('date <= ?',Date.today) == [] ? "" : HostScribe.where('date <= ?',Date.today).order("date asc").last.scribe
  
    @name_initial = current_user.first_name.chr + current_user.last_name.chr

    @workspace_head = ["lvcagadas@cem-inc.org.ph"]
    @workspace_isu = ["rcjamilano@cem-inc.org.ph", "rmina@cem-inc.org.ph", "jpbocatija@cem-inc.org.ph"]
    @workspace_nssu = ["gsibayan@cem-inc.org.ph", "fviceral@cem-inc.org.ph","jcaniedo@cem-inc.org.ph"]
    if params[:ws_id]
      ProjectWorkspace.find(params[:ws_id]).assigned.each do |user|
        if !@workspace_isu.include?(user)
          @workspace_isu.push(user)
        end
        if !@workspace_nssu.include?(user)
          @workspace_nssu.push(user)
        end
      end
    end
    #names must not have spaces
    @conclusion_lists = ["Larry","Ralph","JohnPaul","George","Jess","Reyn","Vice"].shuffle()
    #Host and Scribe
    @hostscribe_date = Addcard.find(params[:id]).host_scribes.pluck(:date)
    @hosts_list = Addcard.find(params[:id]).host_scribes.pluck(:host)
    @scribes_list = Addcard.find(params[:id]).host_scribes.pluck(:scribe)
    @users = ["Select User:"] + User.pluck(:first_name)
  end

  # GET /addcards/1 or /addcards/1.json
  def show
  end

  # GET /addcards/new
  def new
    # @addcard = Addcard.new
  end

  # GET /addcards/1/edit
  def edit
    @addcard = @card.addcards.find(params[:id])
  end

  def edit_comment
    @edit_comment = Addcomment.find(params[:comment_id])
  end

  # POST /addcards or /addcards.json
  def create
    @addcard = @card.addcards.new(addcard_params)
    @page_value = params[:addcard][:page_scroll].to_i

    respond_to do |format|
      if @addcard.save
        format.html { redirect_to view_cards_path({page_scroll:@page_value}), notice: "Addcard was successfully created." }
        format.json { render :show, status: :created, location: @addcard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @addcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addcards/1 or /addcards/1.json
  def update
    @addcard = @card.addcards.find(params[:id])
    respond_to do |format|
      if @addcard.update(addcard_params)
        format.html { redirect_to view_addcards_path, notice: "Addcard was successfully updated." }
        format.json { render :show, status: :ok, location: @addcard }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @addcard.errors, status: :unprocessable_entity }
      end
    end
  end

  def attendance
    @present = @card.addcards.find(params[:id])
    if params[:status] == "present"
      if @present.desc.blank?
        @present.update(desc:current_user.first_name + " - " + "Present")
        redirect_to view_addcards_path
      else
        if @present.desc.include? current_user.first_name
          redirect_to view_addcards_path
        else
          @present.update(desc:@present.desc + "\n" + current_user.first_name + " - " + "Present")
          redirect_to view_addcards_path
        end
      end
    else
      @present.update(desc:"")
      redirect_to view_addcards_path
    end
  end

  # DELETE /addcards/1 or /addcards/1.json
  def destroy
    @deletecard = @card.addcards.find(params[:id])
    @page_value = params[:page_scroll].to_i
    # delete all comments inside the addcard
    @deletecard.addcomments.destroy_all
    # delete addcard
    @deletecard.destroy

    respond_to do |format|
      format.html { redirect_to view_cards_path({page_scroll:@page_value}), notice: "Addcard was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Todo Section
  def create_todo
    @todo = current_user.todos.new(todo_params)
    respond_to do |format|
      if @todo.save
        format.html { redirect_to view_addcards_path, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @addcard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @addcard.errors, status: :unprocessable_entity }
      end
    end  
  end

  def delete_todo
    Todo.find(params[:todo_id]).destroy
    redirect_to view_addcards_path
  end

  def update_todo
    todo_id = params[:todo][:todo_id].to_i
    Todo.find(todo_id).update(todo_params)
    redirect_to view_addcards_path
  end
  def update_checkbox
    if params[:todo][:checkbox_done] == "true"
      finish_date = Date.today
    else
      finish_date = ""
    end
    checkbox_id = params[:todo][:checkbox_id].to_i
    Todo.find(checkbox_id).update(done:params[:todo][:checkbox_done],done_date:finish_date)
    redirect_to view_addcards_path
  end

  # Identify Section
  def create_identify
    @identify = current_user.identifies.new(identify_params)
    respond_to do |format|
      if @identify.save
        format.html { redirect_to view_addcards_path, notice: "Identify was successfully created." }
        format.json { render :show, status: :created, location: @addcard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @addcard.errors, status: :unprocessable_entity }
      end
    end  
  end

  def delete_identify
    Identify.find(params[:identify_id]).destroy
    redirect_to view_addcards_path
  end

  def update_identify
    identify_id = params[:identify][:identify_id].to_i
    Identify.find(identify_id).update(identify_params)
    if params[:from] == "scribe_view"
      redirect_to view_cards_path({scribe_section_view:"ids"})
    else
      redirect_to view_addcards_path
    end
  end
  def update_identify_checkbox
    if params[:identify][:checkbox_done] == "true"
      finish_date = Date.today
    else
      finish_date = ""
    end
    checkbox_id = params[:identify][:checkbox_id].to_i
    Identify.find(checkbox_id).update(done:params[:identify][:checkbox_done], done_date:finish_date)
    redirect_to view_addcards_path
  end  

  def update_conclusion
    desc = ""
    params_value = params[:addcard]
    average = (params_value["JohnPaul 3"].to_i + params_value["Jess 3"].to_i + params_value["Vice 3"].to_i  + params_value["Larry 3"].to_i  + params_value["George 3"].to_i  + params_value["Reyn 3"].to_i  + params_value["Ralph 3"].to_i) / 7.00
    average_score= "<div class='btn btn-success' style='font-weight:bold'>" + "AVERAGE SCORE = " + sprintf('%.2f', average) + "</div>"
    jp = "John Paul - " + params_value["JohnPaul 0"] + ", " + params_value["JohnPaul 1"] + ", " + params_value["JohnPaul 2"] + " = " + params_value["JohnPaul 3"] + "\n"
    jess = "Jess - " + params_value["Jess 0"] + ", " + params_value["Jess 1"] + ", " + params_value["Jess 2"] + " = " + params_value["Jess 3"] + "\n"
    vice = "Vice - " + params_value["Vice 0"] + ", " + params_value["Vice 1"] + ", " + params_value["Vice 2"] + " = " + params_value["Vice 3"] + "\n"
    larry = "Larry - " + params_value["Larry 0"] + ", " + params_value["Larry 1"] + ", " + params_value["Larry 2"] + " = " + params_value["Larry 3"] + "\n"
    george = "George - " + params_value["George 0"] + ", " + params_value["George 1"] + ", " + params_value["George 2"] + " = " + params_value["George 3"] + "\n"
    reyn = "Reyn - " + params_value["Reyn 0"] + ", " + params_value["Reyn 1"] + ", " + params_value["Reyn 2"] + " = " + params_value["Reyn 3"] + "\n"
    ralph = "Ralph - " + params_value["Ralph 0"] + ", " + params_value["Ralph 1"] + ", " + params_value["Ralph 2"] + " = " + params_value["Ralph 3"] + "\n"
    params_value[:conclusion_lists].split(" ").each do |name|
      case 
        when name == "JohnPaul"
          desc += jp
        when name == "Vice"
          desc += vice
        when name == "Reyn"
          desc += reyn
        when name == "Ralph"
          desc += ralph
        when name == "Larry"
          desc += larry
        when name == "George"
          desc += george
        when name == "Jess"
          desc += jess
        else
      end
    end

    @addcard = @card.addcards.find(params[:id])
    respond_to do |format|
      if @addcard.update(desc: desc + average_score)
        if params[:from] == "scribe_view"
          @mom_card_id = CreateBoard.find(params[:cb_id]).cards.order("created_at asc").where("card_title ILIKE ?", "mom").last.id
          @mom_addcard_id = CreateBoard.find(params[:cb_id]).cards.order("created_at asc").where("card_title ILIKE ?", "mom").last.addcards.last.id
          format.html { redirect_to view_addcards_path(params[:cb_id].to_i,@mom_card_id,@mom_addcard_id), notice: "Addcard was successfully updated." }
          format.json { render :show, status: :ok, location: @addcard }
        else
          format.html { redirect_to view_addcards_path, notice: "Addcard was successfully updated." }
          format.json { render :show, status: :ok, location: @addcard }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @addcard.errors, status: :unprocessable_entity }
      end
    end
  end

  def generate_mom
    current_date = CreateBoard.find(params[:cb_id]).cards.where("card_title ILIKE ?", "conclusion").last.addcards.last.updated_at.strftime("%B %d, %Y").to_s 
    mom_summary = "<b><u> #{current_date} </u></b>" + ""
    first_name = User.find_by(first_name:params[:addcard]["scribe_name"]).first_name
    last_name = User.find_by(first_name:params[:addcard]["scribe_name"]).last_name
    CreateBoard.find(params[:cb_id]).cards.each do |card|
      case 
        when card.card_title.downcase.include?("attendance")
          mom_summary += "\n <b>* Attendance *</b>" + "<p>#{card.addcards.last.desc}</p>"
          card.addcards.last.addcomments.create(comment: current_date + "\n" + card.addcards.last.desc, first_name:first_name, last_name:last_name, addcard_id: card.addcards.last.id)
          card.addcards.last.update(desc:"")
        when card.card_title.downcase.include?("segue")
          mom_summary += "\n <b>* Intro / Segue * </b>" + "<p>#{card.addcards.last.desc}</p>"
          card.addcards.last.addcomments.create(comment: current_date + "\n" + card.addcards.last.desc, first_name:first_name, last_name:last_name, addcard_id: card.addcards.last.id)
          card.addcards.last.update(desc:"")
        when card.card_title.downcase.include?("headlines")
          mom_summary += "\n <b>* People Headlines * </b>" + "<p>#{card.addcards.last.desc}</p>"
          card.addcards.last.addcomments.create(comment: current_date + "\n" + card.addcards.last.desc, first_name:first_name, last_name:last_name, addcard_id: card.addcards.last.id)
          card.addcards.last.update(desc:"")
        when card.card_title.downcase.include?("todo")
          todo_summary = ""
          reyn,jp,ralph,larry,george,vice,jesstoni = " - Renante \n"," \n - John Paul \n"," \n - Ralph Christian \n"," \n - Larry Vincent \n", " \n - George \n", " \n - FRANCISCO \n", " \n - Jesstoni \n"
          card.addcards.last.todos.each do |todo|
            status = todo.done ? " - done" : " - in progress"
            if todo.user_id == 13
              reyn += todo.task + status + "\n"
            elsif todo.user_id == 2
              jp += todo.task + status + "\n"
            elsif todo.user_id == 15
              ralph += todo.task + status + "\n"
            elsif todo.user_id == 14
              larry += todo.task + status + "\n"
            elsif todo.user_id == 12
              george += todo.task + status + "\n"
            elsif todo.user_id == 16
              vice += todo.task + status + "\n"
            elsif todo.user_id == 18
              jesstoni += todo.task + status + "\n"
            else
            end
          end
          todo_summary = reyn + jp + ralph + larry + george + vice + jesstoni
          mom_summary += "\n <b> * Todo's * </b> " + "<p> #{todo_summary} </p>"
        when card.card_title.downcase.include?("ids")
          ids_summary = ""
          reyn,jp,ralph,larry,george,vice,jesstoni = " - Renante \n"," \n - John Paul \n"," \n - Ralph Christian \n"," \n - Larry Vincent \n", " \n - George \n", " \n - FRANCISCO \n", " \n - Jesstoni \n"
          card.addcards.last.identifies.each do |identify|
            if identify.user_id == 13
              reyn += "* * " + identify.task + "\n" + "<i>#{identify.solution}</i>" + "\n"
            elsif identify.user_id == 2
              jp += "* * " + identify.task + "\n" + "<i>#{identify.solution}</i>" + "\n"
            elsif identify.user_id == 15
              ralph += "* * " + identify.task + "\n" + "<i>#{identify.solution}</i>" + "\n"
            elsif identify.user_id == 14
              larry += "* * " + identify.task + "\n" + "<i>#{identify.solution}</i>" + "\n"
            elsif identify.user_id == 12
              george += "* * " + identify.task + "\n" + "<i>#{identify.solution}</i>" + "\n"
            elsif identify.user_id == 16
              vice += "* * " + identify.task + "\n" + "<i>#{identify.solution}</i>" + "\n"
            elsif identify.user_id == 18
              jesstoni += "* * " + identify.task + "\n" + "<i>#{identify.solution}</i>" + "\n"
            else
            end
          end
          ids_summary = reyn + jp + ralph + larry + george + vice + jesstoni
          mom_summary += "\n <b> * IDS * </b> " + "<p> #{ids_summary} </p>"          
        when card.card_title.downcase.include?("conclusion")
          mom_summary += "\n <b>* Conclusion * </b>" + "<div> #{card.addcards.last.desc} </div>" 
          card.addcards.last.addcomments.create(comment: current_date + "\n" + card.addcards.last.desc, first_name:first_name, last_name:last_name, addcard_id: card.addcards.last.id)
          card.addcards.last.update(desc:"")
        else
      end
    end
    Addcard.find(params[:id]).addcomments.create(comment: mom_summary, first_name:first_name, last_name:last_name, addcard_id: params[:id])

    respond_to do |format|
      format.html { redirect_to view_addcards_path, notice: "MoM generation successful!" }
    end
  end
  def create_hostandscribe
    Addcard.find(params[:id]).host_scribes.destroy_all
    [1,2,3,4].each do |number|
      HostScribe.create(date:params[:addcard]["date#{number}"], host:params[:addcard]["host#{number}"],scribe:params[:addcard]["scribe#{number}"],addcard_id:params[:id])
    end
    redirect_to view_addcards_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_addcard
    #   @addcard = Addcard.find(params[:id])
    # end

    def get_card
      @card = Card.find(params[:card_id])
    end

    # Only allow a list of trusted parameters through.
    def addcard_params
      params.require(:addcard).permit(:card_name, :desc)
    end

    def todo_params
      params.require(:todo).permit(:task, :addcard_id)
    end

    def identify_params
      params.require(:identify).permit(:task, :addcard_id, :solution)
    end
end
