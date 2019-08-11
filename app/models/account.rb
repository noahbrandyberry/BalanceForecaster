class Account < ApplicationRecord
    belongs_to :user
    has_many :items
    
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
        items.each do |item| 
            occurrences += item.occurrences_between(date_range).map { |occurrence_date| Occurrence.new(item, occurrence_date) }
        end
        occurrences.sort_by!{|o| [o.date, o.is_bill ? 1 : 0, o.name, o.item_id]}

        occurrences
    end

    def balance_before occurrence
        balance + items.starts_before(occurrence.date).sum { |i| i.amount_before(occurrence) }
    end
end
