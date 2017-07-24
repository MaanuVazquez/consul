class BudgetInvestmentNotificationsController < ApplicationController
  load_and_authorize_resource except: [:new]

  def new
    @budget_investment = Budget::Investment.find(params[:budget_investment_id])
    @notification = BudgetInvestmentNotification.new(budget_investment_id: @budget_investment.id)
    authorize! :new, @notification
  end

  def create
    @notification = BudgetInvestmentNotification.new(budget_investment_notification_params)
    @budget_investment = Budget::Investment.find(budget_investment_notification_params[:budget_investment_id])
    if @notification.save
      @budget_investment.voters.each do |voter|
        Notification.add(voter.id, @notification)
      end
      redirect_to @notification, notice: I18n.t("flash.actions.create.proposal_notification")
    else
      render :new
    end
  end

  def show
    @notification = BudgetInvestmentNotification.find(params[:id])
  end

  private

    def budget_investment_notification_params
      params.require(:budget_investment_notification).permit(:title, :body, :budget_investment_id)
    end

end