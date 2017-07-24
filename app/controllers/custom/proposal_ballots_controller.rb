class ProposalBallotsController < ApplicationController

  skip_authorization_check

  def index
    redirect_to budget_group_path @last_budget, @first_group if @last_budget.balloting?
  end

end
