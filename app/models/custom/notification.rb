require_dependency Rails.root.join('app', 'models', 'notification').to_s

class Notification < ActiveRecord::Base

  def notifiable_title
    case notifiable.class.name
    when "ProposalNotification"
      notifiable.proposal.title
    when "BudgetInvestmentNotification"
      notifiable.budget_investment.title
    when "Comment"
      notifiable.commentable.title
    else
      notifiable.title
    end
  end

  def notifiable_action
    case notifiable_type
    when "ProposalNotification"
      "proposal_notification"
    when "BudgetInvestmentNotification"
      "budget_investment_notification"
    when "Comment"
      "replies_to"
    else
      "comments_on"
    end
  end

  def linkable_resource
    if notifiable.is_a?(ProposalNotification)
      notifiable.proposal
    elsif notifiable.is_a?(BudgetInvestmentNotification)
      notifiable.budget_investment
    else
      notifiable
    end
    # notifiable.is_a?(ProposalNotification) ? notifiable.proposal : notifiable
  end

end