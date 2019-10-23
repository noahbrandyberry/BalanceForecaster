class AddBudgetToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :budget, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
