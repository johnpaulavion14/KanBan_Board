class CardsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_card, only: %i[ show edit update destroy ]

  # GET /cards or /cards.json
  def index
    # @cards = current_user.create_boards.find(params[:cb_id]).cards
    @cards = CreateBoard.find(params[:cb_id]).cards.order("created_at asc")
    @addcards = CreateBoard.find(params[:cb_id]).addcards.order("created_at asc")
    
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

    respond_to do |format|
      if @card.save
        format.html { redirect_to view_cards_path(params[:cb_id]), notice: "Card was successfully created." }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cards/1 or /cards/1.json
  def update
    respond_to do |format|
      @card = CreateBoard.find(params[:cb_id]).cards.find(params[:card_id])
      if @card.update(card_params)
        format.html { redirect_to view_cards_path(params[:cb_id]), notice: "Card was successfully updated." }
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
      format.html { redirect_to view_cards_path(params[:cb_id]), notice: "Card was successfully destroyed." }
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
