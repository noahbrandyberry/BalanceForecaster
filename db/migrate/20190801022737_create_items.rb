class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.integer  "account_id"
      t.string   "name", default: "", null: false
      t.boolean  "is_bill", default: false, null: false
      t.boolean  "repeat", default: false, null: false
      t.integer  "repeat_frequency", default: 1
      t.integer  "repeat_type", default: 2
      t.decimal  "amount", precision: 8, scale: 2, default: 0.0
      t.date     "start_date", null: false
      t.date     "end_date"
      t.text     "note"
      t.integer  "category_id"

      t.timestamps
    end
  end
end
