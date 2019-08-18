@javascript @orders
Feature: User can work with cart
  As user
  I want to be able to add, edit and remove items from cart
  So I can create or delete order as I want

  Background:
    Given There are products:
      | name      | price |
      | Coca-cola | 1.2   |
      | Fanta     | 1.3   |
      | Sprite    | 1.5   |
    And User is in application
    And There is an order with items:
      | item      | quantity |
      | Fanta     | 3        |
      | Sprite    | 1        |
      | Coca-cola | 1        |

  Scenario: Order product
    When User adds items to cart:
      | item      | quantity |
      | Fanta     | 2        |
      | Coca-cola | 1        |
    And User removes items from cart:
      | item  |
      | Fanta |
    And User adds items to cart:
      | item   | quantity |
      | Sprite | 1        |
    Then User is able to submit order

  Scenario: Delete order
    When User is finding order with ID 200
    And User deletes order with ID 2
    Then Order with ID 2 is deleted