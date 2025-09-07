require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new

    assert_predicate product, :invalid?
    assert_predicate product.errors[:title], :any?
    assert_predicate product.errors[:description], :any?
    assert_predicate product.errors[:price], :any?
    assert_predicate product.errors[:image], :any?
  end

  test "product price must be possitive" do
    product = Product.new(title: "My book Title", description: "yyy")
    product.image.attach(io: File.open("test/fixtures/files/lorem.jpg"), filename: "lorem.jpg", content_type: "image/jpeg")

    product.price = -1

    assert_predicate product, :invalid?
    assert_equal [ "must be greater than or equal to 0.01" ], product.errors[:price]

    product.price = 0

    assert_predicate product, :invalid?
    assert_equal [ "must be greater than or equal to 0.01" ], product.errors[:price]

    product.price = 1

    assert_predicate product, :valid?
  end

  test "image url" do
    product = new_product("lorem.jpg", "image/jpeg")

    assert_predicate product, :valid?, "image/jpeg must be valid"

    product = new_product("logo.svg", "image/svg+xml")

    assert_predicate product, :invalid?, "image/svg+xml must be invalid"
  end

  def new_product(filename, content_type)
    Product.new(title: "My book Title", description: "yyy", price: 1).tap do |product|
      product.image.attach(io: File.open("test/fixtures/files/#{filename}"), filename:, content_type:)
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(
      title: products(:pragprog).title,
      description: "yyy",
      price: 1
    )

    product.image.attach(
      io: File.open("test/fixtures/files/lorem.jpg"),
      filename: "lorem.jpg",
      content_type: "image/jpeg"
    )

    assert_predicate product, :invalid?
    assert_equal [ I18n.t("errors.messages.taken") ], product.errors[:title]
  end

  test "product title needs to have more than 10 characters" do
    product = Product.new(description: "yyy", price: 1.01)
    product.image.attach(io: File.open("test/fixtures/files/lorem.jpg"), filename: "lorem.jpg", content_type: "image/jpeg")

    product.title = "book56789"

    assert_predicate product, :invalid?
    assert_equal [ "is too short (minimum is 10 characters)" ], product.errors[:title]

    product.title = "book567891"

    assert_predicate product, :valid?
  end
end
