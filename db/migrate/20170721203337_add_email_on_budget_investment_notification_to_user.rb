class AddEmailOnBudgetInvestmentNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_on_budget_investment_notification, :boolean, default: true
  end
end
