class AddConfirmedHideAtToBudgetInvestments < ActiveRecord::Migration
  def up
    add_column :budget_investments, :confirmed_hide_at, :datetime
  end

  def down
    remove_column :budget_investments, :confirmed_hide_at
  end
end
