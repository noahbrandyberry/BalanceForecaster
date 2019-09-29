class ItemsController < ApplicationController
  before_action :set_account
  before_action :set_item, only: [:show, :edit, :update, :destroy, :edit_occurrence, :update_occurrence]
  before_action :create_or_find_category, only: [:create, :update]
  before_action :authenticate_user!

  def index
    @items = @account.items.order(:start_date, :is_bill, :name, :id).includes(:category)
    @past_items = @account.items.past
    @item = @account.items.new
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
        format.js
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to account_items_path(@account), notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to account_items_path(@account), notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  def forecast
    @forecast = @account.forecast(Date.today.prev_month.prev_month.beginning_of_month..Date.today.end_of_year)
    @item = @account.items.new
  end

  def edit_occurrence
    if @item.repeat?
      @occurrence = @item.occurrence_on params[:date].to_date
    else
      render :edit
    end
  end

  def update_occurrence
    params[:occurrence][:new_date] = params[:occurrence][:date] if params[:occurrence][:date]
    @occurrence = @item.occurrence_on params[:date].to_date
    @occurrence.update(occurrence_params)

    respond_to do |format|
      format.html { redirect_to account_items_path(@account), notice: 'Item was successfully updated.' }
      format.json { render :show, status: :ok, location: @occurrence }
      format.js
    end
  end

  private
    def set_account
      @account = Account.find(params[:account_id])
    end

    def set_item
      @item = @account.items.find(params[:id])
    end

    def create_or_find_category
      if params[:item][:category_id] === "new"
        params[:item][:category_id] = Category.find_or_create_by(name: params[:new_category], user: @account.user).try(:id)
      end
    end

    def item_params
      params.require(:item).permit(:name, :is_bill, :repeat, :repeat_frequency, :repeat_type, :amount, :start_date, :end_date, :note, :category_id)
    end

    def occurrence_params
      params.require(:occurrence).permit(:name, :is_bill, :amount, :new_date, :continues)
    end
end
