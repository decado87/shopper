class OrdersController < ApplicationController

  def new
    @order = current_cart.order
  end

  def create
    @order = current_cart.order

    if @order.update_attributes(status: 'open')
      session[:cart_token] = nil
      redirect_to root_path
      flash[:success] = "Order with ID - #{@order.id} has been submitted!"
    else
      render :new
    end
  end

  def find
  end

  def redirect_order
    parameters = params.permit(params.keys).to_h
    redirect_to order_path(parameters[:id])
  end

  def order
    begin
      @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:success] = "Order doesn't exist!"
      redirect_to find_path
    end
    if !@order.nil? && @order.status == 'cart'
      flash[:success] = "Order is not complete yet!"
      redirect_to find_path
    end
  end

  def delete_order
    @order = Order.find(params[:id])
    @order.destroy
    flash[:success] = "Order with ID - #{@order.id} has been deleted!"
    redirect_to root_path
  end

end