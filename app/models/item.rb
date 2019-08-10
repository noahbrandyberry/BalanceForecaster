class Item < ApplicationRecord
    belongs_to :account
    belongs_to :category, optional: true
    
    validates :account, presence: true
    validates :name, presence: true
    validates :repeat_frequency, presence: true, numericality: { greater_than: 0 }, if: :repeat?
    validates :repeat_type, presence: true, if: :repeat?
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :start_date, presence: true

    enum repeat_type: [ :day, :week, :month, :year ]
    
    scope :past, -> { where(repeat: false).where('start_date < ?', Date.today).or(where(repeat: true).where('end_date < ?', Date.today)) }
    scope :future, -> { where(repeat: false).where('start_date > ?', Date.today).or(where(repeat: true).where('end_date > ?', Date.today).or(where(repeat: true, end_date: nil))) }

    def form_date format = '%m/%d/%Y'
        if !new_record?
            repeat && end_date ? "#{start_date.strftime(format)} - #{end_date.strftime(format)}" : start_date.strftime(format)
        end
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

    def occurrences_between date_range
        date = first_occurence_after(date_range.begin)
        occurrences = [date]
        max_date = end_date ? [date_range.end, end_date].min : date_range.end

        if repeat
            date += repeat_frequency.send(repeat_type)

            while date <= max_date
                occurrences << date
                date += repeat_frequency.send(repeat_type)
            end
        end

        occurrences
    end
end
