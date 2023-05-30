class CreateBoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_create_board, only: %i[ show update_group edit update destroy ]

  # GET /create_boards or /create_boards.json
  def index
    @create_boards = current_user.create_boards.where(group:false)
  end

  # GET /create_boards/1 or /create_boards/1.json
  def update_group
    @create_board.update(group:params[:group])
    redirect_to dashboard_path
  end

  def show
  end

  # GET /create_boards/1/edit
  def edit
  end

  # POST /create_boards or /create_boards.json
  def create
    @create_board = current_user.create_boards.new(create_board_params)

    respond_to do |format|
      if @create_board.save
        format.html { redirect_to dashboard_path, notice: "Create board was successfully created." }
        format.json { render :show, status: :created, location: @create_board }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @create_board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /create_boards/1 or /create_boards/1.json
  def update
    respond_to do |format|
      if @create_board.update(create_board_params)
        format.html { redirect_to dashboard_path, notice: "Create board was successfully updated." }
        format.json { render :show, status: :ok, location: @create_board }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @create_board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /create_boards/1 or /create_boards/1.json
  def destroy
    # destroy comments,addcards and cards
    @create_board.cards.each do |card|
      card.addcards.each do |addcard|
        addcard.addcomments.destroy_all
        addcard.destroy
      end
      card.destroy
    end
    # destroy board
    @create_board.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_path, notice: "Create board was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_create_board
      @create_board = CreateBoard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def create_board_params
      params.require(:create_board).permit(:board_title, :board_desc)
    end
end
