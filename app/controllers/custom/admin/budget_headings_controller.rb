require_dependency Rails.root.join('app', 'controllers', 'admin/budget_headings_controller').to_s

class Admin::BudgetHeadingsController < Admin::BaseController

  private

    def budget_heading_params
      params.require(:budget_heading).permit(:name, :price, :padron, :ingreso_promedio, :pct_ingreso_inverso, :pct_habitante, :geozone_id)
    end

end