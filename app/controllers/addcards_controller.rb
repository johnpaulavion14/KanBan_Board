class AddcardsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_card, only: %i[ index edit edit_desc create update destroy attendance]
  # before_action :set_addcard, only: %i[ show edit update destroy ]

  # GET /addcards or /addcards.json
  def index
    @board = CreateBoard.find(params[:cb_id])
    @addcard = @card.addcards.find(params[:id])
    @card_name = @addcard.card
    @desc_value = @addcard.desc.to_s.gsub(/\n/, '<br/>').html_safe
    @comments = Addcomment.all.where(addcard_id: params[:id]).order("created_at desc")

    @name_initial = current_user.first_name.chr + current_user.last_name.chr

    @hosts = User.where(host:"true").order("created_at asc").pluck(:first_name)
    @scribes = User.where(scribe:"true").order("created_at asc").pluck(:first_name)

    @workspace_head = ["lvcagadas@cem-inc.org.ph"]
    @workspace_isu = ["rcjamilano@cem-inc.org.ph", "rmina@cem-inc.org.ph", "jpbocatija@cem-inc.org.ph"]
    @workspace_nssu = ["gsibayan@cem-inc.org.ph", "fviceral@cem-inc.org.ph","jcaniedo@cem-inc.org.ph"]
    if params[:format]
      ProjectWorkspace.find(params[:format]).assigned.each do |user|
        if !@workspace_isu.include?(user)
          @workspace_isu.push(user)
        end
        if !@workspace_nssu.include?(user)
          @workspace_nssu.push(user)
        end
      end
    end
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
        @present.update(desc:Date.current.strftime("%B %d, %Y") + "\n" + current_user.first_name + " - " + "Present")
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
end
