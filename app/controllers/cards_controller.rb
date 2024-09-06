class CardsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_card, only: %i[ show edit update destroy ]

  # GET /cards or /cards.json
  def index
    # @cards = current_user.create_boards.find(params[:cb_id]).cards
    @cards = CreateBoard.find(params[:cb_id]).cards.order("created_at asc")
    @addcards = CreateBoard.find(params[:cb_id]).addcards.order("created_at asc")
    @board = CreateBoard.find(params[:cb_id])
    @host = HostScribe.where('date <= ?',Date.today) == [] ? "" : HostScribe.where('date <= ?',Date.today).order("date asc").last.host
    @scribe = HostScribe.where('date <= ?',Date.today) == [] ? "" : HostScribe.where('date <= ?',Date.today).order("date asc").last.scribe

    # Attendance
    @attendance_view = @cards.where(card_title:"Attendance").last.addcards.last.desc.to_s.gsub(/\n/, '<br/>').html_safe
    # Segue
    @segue_view = @cards.where("card_title ILIKE ?", "%segue%").last.addcards.last.desc.to_s.gsub(/\n/, '<br/>').html_safe
    #Rocks
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
    @scribe = HostScribe.where('date <= ?',Date.today) == [] ? "" : HostScribe.where('date <= ?',Date.today).order("date asc").last.scribe
    # Headlines
    @headlines_view = @cards.where("card_title ILIKE ?", "%headlines%").last.addcards.last.desc.to_s.gsub(/\n/, '<br/>').html_safe

    # Todo
    @todo_addcard = @cards.where("card_title ILIKE ?", "todo's").last.addcards.last
    @todo_list = @todo_addcard.todos.order("created_at asc")
    # IDS
    @ids_addcard = @cards.where("card_title ILIKE ?", "ids").last.addcards.last
    @ids_list = @ids_addcard.identifies.order("created_at asc")

    #Conclusion
    #names must not have spaces
    @conclusion_lists = ["Larry","Ralph","JohnPaul","George","Jess","Reyn","Vice"].shuffle()
    @conclusion_card_id = @cards.where("card_title ILIKE ?", "conclusion").last.id
    @conclusion_addcard_id = @cards.where("card_title ILIKE ?", "conclusion").last.addcards.last.id
  end

  # GET /cards/1 or /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = current_user.cards.new
  end

  # POST /cards or /cards.json
  def create
    @card = CreateBoard.find(params[:cb_id]).cards.new(card_params)
    @page_value = params[:card][:page_scroll].to_i + 1000

    respond_to do |format|
      if @card.save
        if Card.last.card_title.downcase == "rocks"
          Card.last.addcards.create(card_name:Card.last.card_title.capitalize, desc:"description")
        end
        format.html { redirect_to view_cards_path({page_scroll:@page_value}), notice: "Card was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1 or /cards/1.json
  def update
    @page_value = params[:card][:page_scroll].to_i
    respond_to do |format|
      @card = CreateBoard.find(params[:cb_id]).cards.find(params[:card_id])
      if @card.update(card_params)
        format.html { redirect_to view_cards_path({page_scroll:@page_value}), notice: "Card was successfully updated." }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1 or /cards/1.json
  def destroy
    @card = CreateBoard.find(params[:cb_id]).cards.find(params[:card_id])
    @page_value = params[:page_scroll].to_i
    # destroy all comment
    alladdcards = @card.addcards
    alladdcards.each do |addcard|
      addcard.addcomments.destroy_all
    end
    # destroy all addcards
    @card.addcards.destroy_all
    # destroy card
    @card.destroy
    

    respond_to do |format|
      format.html { redirect_to view_cards_path({page_scroll:@page_value}), notice: "Card was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_card
    #   @card = current_user.cards.find(params[:id])
    # end

    # Only allow a list of trusted parameters through.
    def card_params
      params.require(:card).permit(:card_title)
    end
end
