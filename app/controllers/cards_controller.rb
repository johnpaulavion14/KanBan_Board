class CardsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_card, only: %i[ show edit update destroy ]

  # GET /cards or /cards.json
  def index
    # @cards = current_user.create_boards.find(params[:cb_id]).cards
    @cards = CreateBoard.find(params[:cb_id]).cards.order("created_at asc")
    @addcards = CreateBoard.find(params[:cb_id]).addcards.order("created_at asc")
    @board = CreateBoard.find(params[:cb_id])
    @hosts = User.where(host:"true").order("created_at asc").pluck(:first_name)
    @scribes = User.where(scribe:"true").order("created_at asc").pluck(:first_name)
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
