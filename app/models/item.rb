class Item < ApplicationRecord
    belongs_to :account
    
    validates :account, presence: true
    validates :name, presence: true
    validates :repeat_frequency, presence: true, numericality: { greater_than: 0 }, if: :repeat?
    validates :repeat_type, presence: true, if: :repeat?
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :start_date, presence: true

    enum repeat_type: [ :day, :week, :month, :year ]

    def display_repeat_details
        if repeat
            "Every #{repeat_frequency > 1 ? repeat_frequency : ''} #{repeat_type.pluralize(repeat_frequency)}"
        end
    end
end
