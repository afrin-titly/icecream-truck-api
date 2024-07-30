class Item < ApplicationRecord
  belongs_to :category
  belongs_to :flavor, optional: true
  has_many :sales

  accepts_nested_attributes_for :flavor

  def as_json(options = {})
    super(options.merge(except: :flavor_id, include: :flavor))
  end
end
