class CardsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_card, only: %i[ show edit update destroy ]

  # GET /cards or /cards.json
  def index
    # @cards = current_user.create_boards.find(params[:cb_id]).cards
    @cards = current_user.create_boards.find(params[:cb_id]).cards
    @addcards = current_user.create_boards.find(params[:cb_id]).addcards
    
  end

  # GET /cards/1 or /cards/1.json
  def show
  end

  # GET /cards/new
  def new
    @card = current_user.cards.new
  end

  # GET /cards/1/edit
  def edit
    @card = current_user.create_boards.find(params[:cb_id]).cards.find(params[:card_id])
  end

  # POST /cards or /cards.json
  def create
    @card = current_user.create_boards.find(params[:cb_id]).cards.new(card_params)

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
      @card = current_user.create_boards.find(params[:cb_id]).cards.find(params[:card_id])
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
    @card = current_user.create_boards.find(params[:cb_id]).cards.find(params[:card_id])
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
