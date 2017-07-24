require_dependency Rails.root.join('app', 'controllers', 'moderation/base_controller').to_s

class Moderation::InvestmentsController < Moderation::BaseController
  include ModerateActions

  has_filters %w{pending_flag_review without_ignored_flag with_ignored_flag all}, only: :index
  has_orders %w{flags created_at}, only: :index

  before_action :load_resources, only: [:index, :moderate]

  # load_and_authorize_resource :budget
  # load_and_authorize_resource :investment, through: :budget, class: "Budget::Investment"


  def search
    @budget_investments = resource_model
                     .search(params[:term])
                     .order(:title)
                     .page(params[:page])
  end

  private

    def resource_model
      Budget::Investment
    end

    def load_resources
      @resources = resource_model.accessible_by(current_ability, :moderate)
    end
end