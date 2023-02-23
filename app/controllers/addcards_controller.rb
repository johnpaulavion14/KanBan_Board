class AddcardsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_card, only: %i[ edit create update destroy ]
  # before_action :set_addcard, only: %i[ show edit update destroy ]

  # GET /addcards or /addcards.json
  def index
    # @addcards = current_user.cards.find(10).addcards.all
    # @addcards = Addcard.all
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
    @addcard = @card.addcards.find(params[:addcard_id])
  end

  # POST /addcards or /addcards.json
  def create
    @addcard = @card.addcards.new(addcard_params)

    respond_to do |format|
      if @addcard.save
        format.html { redirect_to cards_path, notice: "Addcard was successfully created." }
        format.json { render :show, status: :created, location: @addcard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @addcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addcards/1 or /addcards/1.json
  def update
    @addcard = @card.addcards.find(params[:addcard_id])
    respond_to do |format|
      if @addcard.update(addcard_params)
        format.html { redirect_to cards_path, notice: "Addcard was successfully updated." }
        format.json { render :show, status: :ok, location: @addcard }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @addcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addcards/1 or /addcards/1.json
  def destroy
    @deletecard = @card.addcards.find(params[:addcard_id])
    @deletecard.destroy

    respond_to do |format|
      format.html { redirect_to cards_path, notice: "Addcard was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_addcard
    #   @addcard = Addcard.find(params[:id])
    # end

    def get_card
      @card = current_user.cards.find(params[:card_id])
    end

    # Only allow a list of trusted parameters through.
    def addcard_params
      params.require(:addcard).permit(:card_name)
    end
end
