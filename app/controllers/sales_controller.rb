class SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_items, only: [:purchase]
  before_action :set_customer, only: %i[purchase]

  # POST /purchase
  # Expected params: { sales: [ { item_id: 1, flavor_id: 2, quantity: 2 }, { item_id: 3, flavor_id: 4, quantity: 1 } ] }
  def purchase
    ActiveRecord::Base.transaction do
      @order = Order.new(user: @user)

      @items.each do |item|
        if item.item.valid? && item.item.stock >= item.quantity
          sale = @order.sales.build(
            item_id: item.item_id,
            quantity: item.quantity,
            total_price: item.item.price * item.quantity
          )

          unless sale.save
            render json: { message: 'Failed to create sale record' }, status: :unprocessable_entity
            raise ActiveRecord::Rollback
          end
          item.item.update(stock: item.item.stock - item.quantity)
        else
          render json: { message: 'SO SORRY!', error: 'Insufficient stock or invalid item' }, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        end
      end
      @order.calculate_total_price
      @order.save!
    end
    render json: { message: 'ENJOY!', order_id: @order.id, total_amount: @order.sales.sum(:total_price) }, status: :created
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: 'Item not found', error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { message: 'Validation error', error: e.message }, status: :unprocessable_entity
  end



  # GET /sales/total_sales
  # Expected params: { month: '2024-08' }
  def total_sales
    # Parse the month parameter
    month = params[:month]
    start_date = Date.parse("#{month}-01")
    end_date = start_date.end_of_month

    # Query to get the total amount for each order in the specified month
    orders = Order
               .where(created_at: start_date..end_date)
               .select('order_number, SUM(sales.total_price) as total_amount')
               .joins(:sales)
               .group('orders.id')
               .order('orders.created_at')

    # Render the result in JSON format
    render json: { orders: orders.map { |order| { order_number: order.order_number, total_amount: order.total_amount } } }
  rescue ArgumentError => e
    render json: { message: 'Invalid month format', error: e.message }, status: :unprocessable_entity
  end

  private

  def set_items
    @items = []
    params.require(:sales).each do |sale_params|
      item = OpenStruct.new(
        item_id: sale_params[:item_id],
        flavor_id: sale_params[:flavor_id],
        quantity: sale_params[:quantity],
        item: Item.find_by(id: sale_params[:item_id], flavor_id: sale_params[:flavor_id])
      )

      unless item.item
        raise ActiveRecord::RecordNotFound, "Item not found with item_id: #{sale_params[:item_id]} and flavor_id: #{sale_params[:flavor_id]}"
      end

      unless item.item.stock >= item.quantity
        render json: { message: 'SO SORRY!', error: "Insufficient stock for item id: #{item.item.id} name: #{item.item.name}" }, status: :unprocessable_entity
      end

      @items << item
    end
  end

  def set_customer
    @user = User.find(customer_params[:user_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: 'User not found', error: e.message }, status: :not_found
  end

  def customer_params
    params.require(:user).permit(:user_id)
  end
end
