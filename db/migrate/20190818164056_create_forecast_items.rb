class CreateForecastItems < ActiveRecord::Migration[6.0]
  def change
    create_table :forecast_items do |t|
      t.integer  "item_id"
      t.date     "date", null: false
      t.date     "new_date"
      t.boolean  "deleted", null: false, default: false
      t.string   "name"
      t.boolean  "is_bill"
      t.decimal  "amount", precision: 8, scale: 2
      t.boolean  "continues", default: false, null: false

      t.timestamps
    end
  end
end
