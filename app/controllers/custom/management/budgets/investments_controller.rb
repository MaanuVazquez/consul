require_dependency Rails.root.join('app', 'controllers', 'management/budgets/investments_controller').to_s

class Management::Budgets::InvestmentsController < Management::BaseController

  before_action :load_categories, only: [:index, :new, :create]

  def create
    @last_budget = @budget
    @investment.terms_of_service = "1"
    @investment.author = managed_user

    if @investment.save
      notice= t('flash.actions.create.notice', resource_name: Budget::Investment.model_name.human, count: 1)
      redirect_to management_budget_investment_path(@budget, @investment), notice: notice
    else
      render :new
    end
  end

  def print
    @investments = @investments.apply_filters_and_search(@budget, params).order(cached_votes_up: :desc).for_render.limit(15)
    @last_budget = @budget
    load_investment_votes(@investments)
  end

  def vote
    user_votes = load_user_votes
    if !user_votes.nil? and user_votes < 10
      @investment.register_selection(managed_user)
    end
    load_investment_votes(@investment)
    respond_to do |format|
      format.html { redirect_to management_budget_investments_path(heading_id: @investment.heading.id) }
      format.js
    end
  end

  private

    def investment_params
      params.require(:budget_investment).permit(:title, :summary, :description, :external_url, :video_url, :heading_id, :tag_list, :organization_name, :location, :terms_of_service)
    end

    def load_user_votes
      !managed_user.blank? ? Vote.where(:voter_id => managed_user.id, :votable_type => Budget::Investment).count : nil
    end

end
