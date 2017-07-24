require_dependency Rails.root.join('app', 'controllers', 'application_controller').to_s

class ApplicationController < ActionController::Base

  before_action :set_last_budget
  before_action :set_last_budget_investments
  before_action :set_budget_investments_supports
  before_action :set_first_group_of_last_budget

  private

    def set_last_budget
      @last_budget = Budget.last
      while @last_budget.groups.empty?
        @last_budget = Budget.where("id < ?",@last_budget.id).first
      end
    end

    def set_last_budget_investments
      @last_budget_investments = Budget::Investment.where(:budget_id => @last_budget.id) if !@last_budget.nil?
    end

    def set_budget_investments_supports
      @budget_investments_supports = current_user ? current_user.budget_investment_votes(@last_budget_investments) : {}
    end

    def set_first_group_of_last_budget
      @first_group = Budget::Group.where(:budget_id => @last_budget.id).first if !@last_budget.nil?
    end

end
