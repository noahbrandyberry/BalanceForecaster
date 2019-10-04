class Account < ApplicationRecord
    belongs_to :user
    has_many :items
    has_many :forecast_items, through: :items
    
    validates :user, presence: true
    validates :name, presence: true
    validates :balance, presence: true

    def available_transfer_accounts
        user.accounts.where.not(id: id)
    end

    def to_s
        name
    end

    def forecast date_range
        occurrences = []
        items.includes(:category, :forecast_items).starts_before(date_range.end).each do |item| 
            occurrences += item.occurrences_between(date_range)
        end
        occurrences.sort_by!{|o| [o.date, o.is_bill ? 1 : 0, o.name, o.item_id]}

        previous_balance = false
        occurrences.each do |occurrence| 
            occurrence.set_balance(previous_balance) if previous_balance
            previous_balance = occurrence.balance
        end

        occurrences
    end

    def balance_before occurrence
        balance + items.starts_before(occurrence.date).sum { |i| i.amount_before(occurrence) }
    end

    def balance_on date = Date.today
        balance + items.starts_before(date).sum { |i| i.total_amount_on(date) }
    end
end
