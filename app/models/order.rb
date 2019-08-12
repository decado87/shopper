class Order < ApplicationRecord

  has_many :items, class_name: 'OrderItem', dependent: :delete_all

  # def find_order(id:)
  #   @order = Order.find(id: id, status: 'cart')
  # end

end
