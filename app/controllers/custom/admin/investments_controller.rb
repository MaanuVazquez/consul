require_dependency Rails.root.join('app', 'controllers', 'admin/budget_investments_controller').to_s

class Admin::InvestmentsController < Admin::BaseController
  has_filters %w{without_confirmed_hide all with_confirmed_hide}, only: :index

  before_action :load_investments, only: [:confirm_hide, :restore]

  def index
    @investments = Budget::Investment.only_hidden.send(@current_filter).order(hidden_at: :desc).page(params[:page])
  end

  def confirm_hide
    @investment.confirm_hide
    redirect_to request.query_parameters.merge(action: :index)
  end

  def restore
    @investment.restore
    @investment.ignore_flag
    Activity.log(current_user, :restore, @investment)
    redirect_to request.query_parameters.merge(action: :index)
  end

  private

    def load_investments
      @investment = Budget::Investment.with_hidden.find(params[:id])
    end

end