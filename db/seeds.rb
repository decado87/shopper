product_names = ['Pepsi', 'Mirinda', '7Up']
prices = [1.2, 1.3, 1,4]

(0..product_names.count - 1 ).each do |i|
  product = Product.new(
    title: product_names[i],
    price: prices[i]
  )

  product.save!
end
