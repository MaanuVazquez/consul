class AddIgnoredFlagAtAndFlagsCountToBudgetInvestments < ActiveRecord::Migration
  def up
    add_column :budget_investments, :flags_count, :integer, default: 0
    add_column :budget_investments, :ignored_flag_at, :datetime
  end

  def down
    remove_column :budget_investments, :flags_count
    remove_column :budget_investments, :ignored_flag_at
  end
end
