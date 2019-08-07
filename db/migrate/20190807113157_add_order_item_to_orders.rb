class AddOrderItemToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :order, foreign_key: true, null: false
  end
end
