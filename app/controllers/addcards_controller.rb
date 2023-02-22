class AddcardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_addcard, only: %i[ show edit update destroy ]

  # GET /addcards or /addcards.json
  def index
    @addcards = Addcard.all
  end

  # GET /addcards/1 or /addcards/1.json
  def show
  end

  # GET /addcards/new
  def new
    @addcard = Addcard.new
  end

  # GET /addcards/1/edit
  def edit
  end

  # POST /addcards or /addcards.json
  def create
    @addcard = Addcard.new(addcard_params)

    respond_to do |format|
      if @addcard.save
        format.html { redirect_to addcard_url(@addcard), notice: "Addcard was successfully created." }
        format.json { render :show, status: :created, location: @addcard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @addcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addcards/1 or /addcards/1.json
  def update
    respond_to do |format|
      if @addcard.update(addcard_params)
        format.html { redirect_to addcard_url(@addcard), notice: "Addcard was successfully updated." }
        format.json { render :show, status: :ok, location: @addcard }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @addcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addcards/1 or /addcards/1.json
  def destroy
    @addcard.destroy

    respond_to do |format|
      format.html { redirect_to addcards_url, notice: "Addcard was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_addcard
      @addcard = Addcard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def addcard_params
      params.require(:addcard).permit(:card_name)
    end
end
