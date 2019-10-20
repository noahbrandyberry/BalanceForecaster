class AddPreferencesAndHiddenAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :preferred_account, :integer
    add_column :accounts, :inactive, :boolean, default: false
  end
end
