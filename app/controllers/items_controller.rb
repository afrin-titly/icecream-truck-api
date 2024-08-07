class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: %i[show update destroy]
  before_action :is_admin, only: %i[create update destroy]

  # GET /items
  def index
    @items = Item.includes(:flavor).all
    render json: @items.as_json(include: :flavor), status: :ok
  end

  # GET /items/1
  def show
    render json: @item, status: :ok
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: @item, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    head :no_content
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :price, :category_id, :flavor_id, :stock, :created_at, :updated_at)
    end
end
