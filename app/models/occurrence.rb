class Occurrence
    attr_reader :item_id, :name, :amount, :is_bill, :note, :category, :date

    def initialize(item, date)  
        @item_id = item.id
        @item = item
        @name = item.name
        @amount = item.amount
        @is_bill = item.is_bill
        @note = item.note
        @category = item.category
        @date = date
        @balance = nil
    end  

    def source
        {item_id: @item_id, name: @name, amount: @amount, is_bill: is_bill, note: @note, category: @category, date: @date, balance: balance}
    end

    def balance_before
        @item.account.balance_before self
    end

    def balance
        @balance ||= balance_before + (@is_bill ? -(@amount.abs) : @amount.abs)
    end
end