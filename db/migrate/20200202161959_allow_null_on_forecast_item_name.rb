class AllowNullOnForecastItemName < ActiveRecord::Migration[6.0]
  def change
    change_column_null :forecast_items, :name, true
  end
end
