class Item < ApplicationRecord
    belongs_to :account
    
    validates :account, presence: true
    validates :name, presence: true
    validates :repeat_frequency, presence: true, if: :repeat?
    validates :repeat_type, presence: true, if: :repeat?
    validates :amount, presence: true
    validates :start_date, presence: true
    validates :transfer_id, presence: true, if: :is_transfer?

    enum repeat_type: [ :days, :weeks, :months, :years ]
end
