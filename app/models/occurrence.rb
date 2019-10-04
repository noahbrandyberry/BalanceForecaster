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

    def previous_occurrences
        @item.occurrences_before(self)
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

    def revert
        @forecast_item.destroy if @forecast_item
    end

    def balance
        @balance ||= balance_before + real_amount
    end

    def category
        @item.category
    end

    def form_source
        {item_id: @item_id, name: @name, amount: @amount.to_s, is_bill: is_bill ? "1" : "0", note: @note, category: @category, new_date: @date.to_s, balance: balance.to_s}.to_a
    end

    def update params
        changed_params = (params.to_h.symbolize_keys.to_a - form_source).to_h

        if forecast_item
            forecast_item.update_attributes(changed_params)
        else
            changed_params[:date] = @date
            @item.forecast_items.create(changed_params)
        end
    end

    def delete
        if forecast_item
            forecast_item.update_attributes(deleted: true)
        else
            @item.forecast_items.create(date: @date, deleted: true)
        end
    end
end