class AddSummaryToBudgetInvestment < ActiveRecord::Migration
  def up
    add_column :budget_investments, :summary, :text , limit: 280
  end

  def down
    remove_column :budget_investments, :summary
  end
end
