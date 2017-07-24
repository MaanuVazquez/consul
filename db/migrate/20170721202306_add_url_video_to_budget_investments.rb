class AddUrlVideoToBudgetInvestments < ActiveRecord::Migration
  def change
    add_column :budget_investments, :video_url, :string
  end
end
