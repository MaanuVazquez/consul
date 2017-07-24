require_dependency Rails.root.join('app', 'helpers', 'banners_helper').to_s

module Custom::BannersHelper

  def banner_path
    if @last_budget.accepting?
      return new_budget_investment_path(budget_id: @last_budget.id)
    elsif @last_budget.selecting?
      return budget_investments_path(@last_budget)
    elsif @last_budget.valuating?
      return "http://bit.ly/WPCateEA"
    elsif @last_budget.balloting?
      return budget_group_path(@last_budget, @first_group)
    end
  end

end