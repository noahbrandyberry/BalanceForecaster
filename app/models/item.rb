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

    def next_occurence
        # Test and get working
    end

    def occurrences_between date_range
        occurrences = []
        date = start_date.to_date
        max_date = end_date ? [date_range.end, end_date].min : date_range.end

        if repeat
            while date <= max_date
                occurrences << date if date >= date_range.begin
                date += repeat_frequency.send(repeat_type)
            end
        else
            occurrences << date if date >= date_range.begin
        end

        occurrences
    end
end
