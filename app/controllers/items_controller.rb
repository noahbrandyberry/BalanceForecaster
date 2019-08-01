class ItemsController < ApplicationController
  before_action :set_account
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = @account.items
  end

  def show
  end

  def new
    @item = @account.items.new
  end

  def edit
  end

  def create
    @item = @account.items.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to account_items_path(@account), notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to account_items_path(@account), notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to account_items_path(@account), notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_account
      @account = Account.find(params[:account_id])
    end

    def set_item
      @item = @account.items.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :is_bill, :repeat, :repeat_frequency, :repeat_type, :amount, :start_date, :end_date, :note, :category_id, :is_transfer, :transfer_id)
    end
end
