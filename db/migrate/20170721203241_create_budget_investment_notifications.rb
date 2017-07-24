class CreateBudgetInvestmentNotifications < ActiveRecord::Migration
  def change
    create_table :budget_investment_notifications do |t|
      t.string :title
      t.text :body
      t.integer :author_id
      t.integer :budget_investment_id

      t.timestamps null: false
    end
  end
end
