class ProductsController < ApplicationController

  def index
    @products = Product.all.order(:title)
  end

end