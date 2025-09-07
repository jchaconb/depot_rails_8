class LineItemsController < ApplicationController
  include CurrentCart

  before_action :set_cart, only: %i[ create ]
  before_action :set_line_item, only: %i[ show edit update destroy ]

  def index
    @line_items = LineItem.all
  end

  def show
  end

  def new
    @line_item = LineItem.new
  end

  def edit
  end

  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: "Line item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    cart = @line_item.cart
    @line_item.destroy!

    respond_to do |format|
      if cart.line_items.count >= 1
        format.html { redirect_to cart, status: :see_other }
      else
        format.html { redirect_to store_index_url, notice: "Your cart is currently empty", status: :see_other }
      end

      format.json { head :no_content }
    end
  end

  private
    def set_line_item
      @line_item = LineItem.find(params.expect(:id))
    end

    def line_item_params
      params.expect(line_item: [ :product_id ])
    end
end
