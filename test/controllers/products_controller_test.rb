require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url

    assert_response :success
  end

  test "should get new" do
    get new_product_url

    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      image = fixture_file_upload(file_fixture("lorem.jpg"), "image/jpeg")

      post products_url, params: { product: { image:, description: "AAA", price: 99.01, title: "New Title" } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)

    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)

    assert_response :success
  end

  test "should update product" do
    image = fixture_file_upload(file_fixture("lorem.jpg"), "image/jpeg")

    patch product_url(@product), params: { product: { image:, description: @product.description, price: @product.price, title: @product.title } }

    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
