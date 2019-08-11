class Order < ApplicationRecord

  has_many :items, class_name: 'OrderItem'

  def find_order(id:)
    @order = Order.find(id: id, status: 'cart')
  end

end
