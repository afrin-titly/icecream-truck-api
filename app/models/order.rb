class Order < ApplicationRecord
  has_many :sales, dependent: :destroy
  belongs_to :user

  before_validation :generate_order_number, on: :create

  validates :order_number, uniqueness: true
  validates :total_amount, presence: true

  def calculate_total_price
    self.update_column(:total_amount, sales.sum(:total_price))
  end

  private

  def generate_order_number
    loop do
      self.order_number = rand(10000..99999).to_s # Generate random 5-digit number
      break unless Order.exists?(order_number: order_number)
    end
  end
end
