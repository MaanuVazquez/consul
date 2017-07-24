require_dependency Rails.root.join('app', 'controllers', 'budgets', 'investments_controller').to_s

module Budgets
  class InvestmentsController < ApplicationController

    before_action :load_investment, only: [:edit, :update]
    before_action :load_categories, only: [:index, :new, :create, :edit, :update]

    def create
      @investment.author = current_user
      @investment.terms_of_service = "1" if current_user.try(:manager?)

      if @investment.save
        Mailer.budget_investment_created(@investment).deliver_later
        redirect_to budget_investment_path(@budget, @investment, gracias: true),
                    notice: t('flash.actions.create.proposal')
      else
        render :new
      end
    end

    def index
      @investments = @investments.apply_filters_and_search(@budget, params).send("sort_by_#{@current_order}").page(params[:page]).per(10).for_render
      @investment_ids = @investments.pluck(:id)
      load_investment_votes(@investments)
      @tag_cloud = tag_cloud
    end

    def summary
      @investments = BudgetInvestment.for_summary
      @tag_cloud = tag_cloud
    end

    def vote
      user_votes = load_user_votes
      if !user_votes.nil? and user_votes < 10
        @investment.register_selection(current_user)
      end
      load_investment_votes(@investment)
      set_budget_investments_supports
      respond_to do |format|
        format.html { redirect_to budget_investments_path(@last_budget) }
        format.js
      end
    end

    def edit
    end

    def update
      if @investment.update(investment_params)
        redirect_to budget_investment_path(@budget, @investment),
                    notice: t("flash.actions.update.proposal")
      else
        render :edit
      end
    end

    private

      def investment_params
        params.require(:budget_investment).permit(:title, :summary, :description, :external_url, :video_url, :heading_id, :tag_list, :organization_name, :location, :terms_of_service)
      end

      def load_investment
        @investment = Budget::Investment.where(budget_id: @budget.id).find params[:id]
      end

      def load_user_votes
        !current_user.blank? ? Vote.where(:voter_id => current_user.id, :votable_type => Budget::Investment).count : nil
      end
  end

end
