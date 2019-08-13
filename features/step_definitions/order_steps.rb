$VERBOSE = nil

Given(/^There are products:$/) do |table|
  # table is a table.hashes.keys # => [:name, :price]
  table.hashes.each do |row|
    product = Product.new(
        title: row[:name],
        price: row[:price]
    )
    product.save!
  end
end

And(/^There is an order with items:$/) do |table|
  # table is a table.hashes.keys # => [:item, :quantity]
  order = Order.create!(status: 'open', sub_total: 0)

  table.hashes.each do |row|
    product = Product.find_by(title: row[:item])

    order_item = order.items.find_or_initialize_by(
        product_id: product.id
    )

    order_item.price = product.price
    order_item.quantity = row[:quantity].to_i

    order.sub_total = order.items.sum('quantity * price')
    order.save

    order_item.save!
  end
end

When(/^User adds items to cart:$/) do |table|
  # table is a table.hashes.keys # => [:item, :quantity]
  find('a', text: 'Home').click if page.has_no_css?('h2', text: 'Products')

  table.hashes.each do |row|
    check_header

    number_of_ordered_items = find('a', text: 'Current cart:').text.split(':')[1].to_i

    item = find('li', text: /#{row[:item]}/i)
    item.find('#quantity').set(row[:quantity])
    item.find("input[value='Add to Cart']").click

    check_notice([row[:quantity], row[:item]])

    check_cart(number_of_ordered_items + row[:quantity].to_i)
  end


end

And(/^User removes items from cart:$/) do |table|
  # table is a table.hashes.keys # => [:item]
  find('a', text: /Current Cart/i).click if page.has_no_css?('h2', text: 'Current Cart')
  table.hashes.each do |row|
    check_header

    number_of_ordered_items = find('a', text: 'Current cart:').text.split(':')[1].to_i

    number_of_rows = page.all('tr').count

    item = find('tr', text: /#{row[:item]}/i)
    quantity_of_item = item.all('td')[3].text.to_i
    item.find('.edit_order_item').click

    # check_notice(error)

    expect(number_of_rows - 1).to eq(page.all('tr').count),
                                  'Item has not been removed from cart!'

    check_cart(number_of_ordered_items - quantity_of_item)
  end
end

Then(/^User is able to submit order$/) do
  find('a', text: /Current Cart/i).click if page.has_no_css?('h2', text: 'Current Cart')
  find('a', text: 'Checkout').click

  page.has_css?('.notice')
  last_order_id = Order.where(status: 'open').sort_by { |order| order.updated_at }.last.id

  check_header
  check_notice("Order with ID - #{last_order_id} has been submitted!")
  check_cart(0)
  expect(page).to have_current_path(@@base_url, url: true),
                  'User has not been redirected to root path!'

  step "User is finding order with ID #{last_order_id}"
  step "Order with ID #{last_order_id} is submitted"
end

When(/^User is finding order with ID (.+)$/) do |id|
  find('a', text: 'Find').click if page.has_no_css?('h2', text: 'Find')

  find('#id').set(id)
  find("input[value='Find order']").click
end

And(/^User deletes order with ID (.+)$/) do |id|
  check_order(id)

  find("input[value='Delete order']").click

  check_notice("Order with ID - #{id} has been deleted!")

  expect(page).to have_current_path(@@base_url, url: true)
end

Then(/^Order with ID (.+) is (submitted|deleted|incomplete)$/) do |id, state|
  step "User is finding order with ID #{id}"

  case state
  when 'submitted'
    check_order(id)
  when 'deleted'
    check_notice("Order doesn't exist!")
  when 'incomplete'
    check_notice('Order is not completed yet!')
  end
end

And(/^User is in application$/) do
  visit(@@base_url)
end

def check_header
  expect(current_url.include?(@@base_url)).to be_truthy,
                                              'User is not in application!'
  expect(page.has_css?('p')).to be_truthy,
                                'Cannot find header!'
  header = find('p')
  header_texts = ['Home', 'Current cart:', 'Find']
  header_texts.each do |text|
    expect(header.has_css?('a', text: text)).to be_truthy,
                                                "Cannot find link with text - #{text} in header"
  end
end

def check_notice(text)
  notice = find('.notice').text
  if text.is_a?(Array)
    text.each do |word|
      expect(notice.include?(word)).to be_truthy,
                                       "Wrong notice message. Expected word to found: #{text} in message: #{notice}"
    end
  else
    expect(text).to eq(notice),
                    "Wrong notice message. Expected: #{text}, found: #{notice}"
  end
end


def check_cart(number)
  current_number = find('a', text: 'Current cart:').text.split(':')[1].to_i
  expect(number).to eq(current_number),
                    "Wrong number of items. Expected: #{number}, found: #{current_number}"
end

def check_order(id)
  expect(page).to have_current_path(@@base_url + "/order/#{id}", url: true)

  heading = find('h2').text
  expect("Order number - #{id}").to eq(heading)
end