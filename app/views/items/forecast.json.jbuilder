@forecast_array = []

@forecast.group_by { |o| o.date.strftime("%B %Y") }.each do |month_name, occurrences|
    @forecast_array << {date: Date.parse(month_name) - 1.day, is_bill: month_name, name: "Name", category: "Category", amount_formatted: "Amount", balance_formatted: "Balance", is_section: true}

    occurrences.each do |occurrence|
        occurrence_json = {item_id: occurrence.item_id, is_bill: occurrence.is_bill, date: occurrence.date, name: occurrence.name, amount: occurrence.amount, balance: occurrence.balance}
        occurrence_json[:day_of_week] = occurrence.date.strftime("%A")
        occurrence_json[:day_of_month] = occurrence.date.day.ordinalize
        occurrence_json[:category] = occurrence.category.to_s
        occurrence_json[:amount_formatted] = number_to_currency(occurrence.real_amount)
        occurrence_json[:balance_formatted] = number_to_currency(occurrence.balance)
        occurrence_json[:is_section] = false

        @forecast_array << occurrence_json
    end
end

json.array! @forecast_array