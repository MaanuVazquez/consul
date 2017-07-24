require_dependency Rails.root.join('app', 'controllers', 'admin/budget_investments_controller').to_s

class Admin::BudgetInvestmentsController < Admin::BaseController

  def edit
    load_admins
    load_valuators
    load_tags
    @categories = ActsAsTaggableOn::Tag.where("kind = 'category'").order(:name)
  end

  private

    def budget_investment_params
      params.require(:budget_investment)
            .permit(:title, :summary, :description, :external_url, :video_url, :heading_id, :tag_list, :administrator_id, :valuation_tag_list, valuator_ids: [])
    end

end
