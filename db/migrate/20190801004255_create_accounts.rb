class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.integer  "user_id"
      t.string   "name",    default: "", null: false
      t.decimal  "balance", precision: 8, scale: 2, default: 0.0, null: false

      t.timestamps
    end
  end
end
