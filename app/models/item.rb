class Item < ApplicationRecord
    belongs_to :account
    belongs_to :category, optional: true

    has_many :forecast_items
    
    validates :account, presence: true
    validates :name, presence: true
    validates :repeat_frequency, presence: true, numericality: { greater_than: 0 }, if: :repeat?
    validates :repeat_type, presence: true, if: :repeat?
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :start_date, presence: true

    enum repeat_type: [ :day, :week, :month, :year ]
    
    scope :past, -> { where(repeat: false).where('start_date < ?', Date.today).or(where(repeat: true).where('end_date < ?', Date.today)) }
    scope :future, -> { where(repeat: false).where('start_date > ?', Date.today).or(where(repeat: true).where('end_date > ?', Date.today).or(where(repeat: true, end_date: nil))) }
    scope :starts_before, -> (date = Date.today) { where('start_date <= ?', date) }

    def form_date format = '%Y/%m/%d'
        if !new_record?
            repeat && end_date ? "#{start_date.strftime(format)} - #{end_date.strftime(format)}" : start_date.strftime(format)
        end
    end

    def occurrences_before occurrence
        # Gets all occurrences before passed in occurrence date
        occurrences = occurrences_between(start_date..occurrence.date)
        occurrences << occurrence
        # Sorts all occurrence including passed in occurrence
        occurrences.sort_by!{|o| [o.date, o.is_bill ? 1 : 0, o.name, o.item_id]}

        index = occurrences.index(occurrence) - (id === occurrence.item_id ? 1 : 0)
        # Removes all occurrences after current occurrence (to account for occurrences on the same day)
        occurrences[0, index]
    end

    def amount_before occurrence
        occurrences_before(occurrence).sum{|o| o.real_amount}
    end

    def occurrences_before_or_on date
        # Gets all occurrences before passed in occurrence date
        occurrences_between(start_date..date)
    end

    def total_amount_on date = Date.today
        occurrences_before_or_on(date).sum{|o| o.real_amount}
    end

    def display_repeat_details include_end_date = true, format = '%m/%d/%Y'
        if repeat
            repeat_details = "Every #{repeat_frequency > 1 ? repeat_frequency : ''} #{repeat_type.pluralize(repeat_frequency)}"

            repeat_details = "#{repeat_details} until #{end_date.strftime(format)}" if include_end_date && end_date

            repeat_details
        end
    end

    def past?
        if repeat
            end_date && Date.today > end_date
        else 
            Date.today > start_date
        end
    end

    def next_occurence format = '%m/%d/%Y', date = Date.today
        repeat ? first_occurence_after(date).strftime(format) : 'Not recurring'
    end

    def previous_occurence format = '%m/%d/%Y', date = Date.today 
        repeat ? last_occurence_before(date).strftime(format) : 'Not recurring'
    end

    def first_occurence_after date
        if date > start_date
            if repeat && (!end_date || date <= end_date)
                # Sets 'interval' to the amount of time between the start date and passed in 'date'. The value will be a rounded up integer that represents the 'repeat_type'.
                case repeat_type
                when 'year'
                    interval = ((date - start_date).to_f / 365).ceil
                when 'month'
                    interval = ((date - start_date).to_f / 365 * 12).ceil
                when 'week'
                    interval = ((date - start_date).to_f / 7).ceil
                when 'day'
                    interval = (date - start_date).ceil
                end

                # Takes the 'repeat_frequency' into account.
                frequency_multiplier = (interval.to_f/repeat_frequency.to_f).ceil
                start_date + (frequency_multiplier*repeat_frequency).send(repeat_type)
            end
        else
            start_date
        end
    end

    def last_occurence_before date
        if date > start_date
            if repeat
                date = end_date if end_date && date > end_date 
                # Sets 'interval' to the amount of time between the start date and passed in 'date'. The value will be a rounded up integer that represents the 'repeat_type'.
                case repeat_type
                when 'year'
                    interval = ((date - start_date).to_f / 365).floor
                when 'month'
                    interval = ((date - start_date).to_f / 365 * 12).floor
                when 'week'
                    interval = ((date - start_date).to_f / 7).floor
                when 'day'
                    interval = (date - start_date).floor
                end

                # Takes the 'repeat_frequency' into account.
                frequency_multiplier = (interval.to_f/repeat_frequency.to_f).floor
                start_date + (frequency_multiplier*repeat_frequency).send(repeat_type)
            else
                start_date
            end
        end
    end

    def occurrence_on date
        occurrences_before_or_on(date).find{|occurrence| occurrence.date === date}
    end

    def occurrences_between date_range
        occurrences = []

        if start_date.between?(date_range.begin, date_range.end) || (start_date <= date_range.end && repeat)

            if repeat
                date = start_date
                max_date = end_date ? [date_range.end, end_date].min : date_range.end
                occurrence_name = name
                occurrence_amount = amount
                occurrence_is_bill = is_bill
                affected_forecast_items = []
                forecast_items.select { |forecast_item|  forecast_item.new_date && forecast_item.new_date <= max_date && forecast_item.date >= max_date }
                forecast_item_max_date = (forecast_items.map(&:date) + [max_date]).max

                while date <= forecast_item_max_date
                    forecast_item = forecast_items.find{|forecast_item| forecast_item.date === date}
                    forecast_item_date = (forecast_item.try(:new_date).nil? ? date : forecast_item.new_date)
                    
                    occurrences << Occurrence.new(self, 
                        forecast_item_date, 
                        (forecast_item.try(:name).nil? ? occurrence_name : forecast_item.name),
                        (forecast_item.try(:amount).nil? ? occurrence_amount : forecast_item.amount),
                        (forecast_item.try(:is_bill).nil? ? occurrence_is_bill : forecast_item.is_bill),
                        forecast_item,
                        affected_forecast_items.clone
                    ) if forecast_item_date >= date_range.begin && forecast_item_date <= max_date && !forecast_item.try(:deleted)

                    if forecast_item.try(:continues)
                        occurrence_name = forecast_item.name if forecast_item.name
                        occurrence_amount = forecast_item.amount if forecast_item.amount
                        occurrence_is_bill = forecast_item.is_bill if forecast_item.is_bill
                        date = forecast_item.new_date if forecast_item.new_date
                        affected_forecast_items << forecast_item
                    end

                    date += repeat_frequency.send(repeat_type)
                end
            else
                occurrences << Occurrence.new(self, start_date)
            end
        end

        occurrences
    end
end
