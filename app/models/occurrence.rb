class Occurrence
    attr_reader :item_id, :name, :amount, :is_bill, :note, :date, :forecast_item, :affected_forecast_items, :continues

    def initialize(item, date, name = nil, amount = nil, is_bill = nil, forecast_item = nil, affected_forecast_items = [])  
        @item_id = item.id
        @item = item
        @forecast_item = forecast_item
        @continues = forecast_item.try(:continues)
        @affected_forecast_items = affected_forecast_items
        @name = name ? name : item.name
        @amount = amount ? amount : item.amount
        @is_bill = is_bill ? is_bill : item.is_bill
        @note = item.note
        @date = date
        @balance = nil
    end  

    def source
        {item_id: @item_id, name: @name, amount: @amount, is_bill: is_bill, note: @note, category: @category, date: @date, balance: balance}
    end

    def balance_before
        @item.account.balance_before self
    end

    def set_balance previous_balance
        @balance = previous_balance + real_amount
    end

    def real_amount
        @is_bill ? -(@amount.abs) : @amount.abs
    end

    def balance
        @balance ||= balance_before + real_amount
    end

    def category
        @item.category
    end
end