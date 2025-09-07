require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  setup do
    @cart = carts(:one)
  end

  test "visiting the index" do
    visit carts_url

    assert_selector "h1", text: "Carts"
  end

  test "should empty Cart" do
    visit cart_url(@cart)

    click_on "Empty Cart", match: :first

    assert_text "Your cart is currently empty"
  end
end
