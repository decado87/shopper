class OrderItemsController < ApplicationController

  def index
    @items = current_cart.order.items
    @items = @items.sort_by{|item| item.product.title.downcase}
  end


  def create
    product = Product.find(params[:product_id])
    quantity = params[:quantity]
    current_cart.add_item(
        product_id: product.id,
        quantity: quantity
    )
    case quantity.to_i
    when -1
      msg = "removed 1 product"
    when 1
      msg = "added 1 product"
    when 0
      msg = "not added product"
    else
      msg = "added #{quantity} products"
    end
    flash[:success] = "You have #{msg} named - #{product.title}."
    redirect_to request.referrer
  end

  def destroy
    current_cart.remove_item(id: params[:id])
    redirect_to cart_path
  end

end