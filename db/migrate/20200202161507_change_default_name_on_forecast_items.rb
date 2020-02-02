class ChangeDefaultNameOnForecastItems < ActiveRecord::Migration[6.0]
  def change
    change_column_null :forecast_items, :name, false
    change_column_default :forecast_items, :name, nil
  end
end
