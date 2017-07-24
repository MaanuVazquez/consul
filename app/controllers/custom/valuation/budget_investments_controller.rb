require_dependency Rails.root.join('app', 'controllers', 'valuation/budget_investments_controller').to_s

class Valuation::BudgetInvestmentsController < Valuation::BaseController

  def edit
    @categories = ActsAsTaggableOn::Tag.where("kind = 'category'").order(:name)
  end

  private

    def valuation_params
      params.require(:budget_investment).permit(:title, :summary, :description, :external_url, :video_url, :tag_list, :heading_id, :price, :price_first_year, :price_explanation, :feasibility, :unfeasibility_explanation, :duration, :valuation_finished, :internal_comments)
    end

end
