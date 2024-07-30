class FlavorsController < ApplicationController
  before_action :set_flavor, only: %i[ show edit update destroy ]

  # GET /flavors or /flavors.json
  def index
    @flavors = Flavor.all
    render json: @flavors, status: :ok
  end

  # GET /flavors/1 or /flavors/1.json
  def show
    render json: @flavor, status: :ok
  end

  # POST /flavors or /flavors.json
  def create
    @flavor = Flavor.new(flavor_params)

    if @flavor.save
      render json: @flavor, status: :created, location: @flavor
    else
      render json: @flavor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /flavors/1 or /flavors/1.json
  def update
    if @flavor.update(flavor_params)
      render json: @flavor, status: :ok
    else
      render json: @flavor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /flavors/1 or /flavors/1.json
  def destroy
    @flavor.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flavor
      @flavor = Flavor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def flavor_params
      params.require(:flavor).permit(:name, :created_at, :updated_at)
    end
end
