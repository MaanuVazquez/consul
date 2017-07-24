require_dependency Rails.root.join('app', 'controllers', 'moderation/base_controller').to_s

class Moderation::BaseController < ApplicationController

  before_action :set_last_budget

  private

    def set_last_budget
      @last_budget = Budget.last
      if @last_budget.present?
        while @last_budget.groups.empty?
          @last_budget = Budget.where("id < ?",@last_budget.id).first
        end
      end
    end

end
