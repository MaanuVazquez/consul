# require_dependency Rails.root.join('app', 'models', 'custom').to_s

class BudgetInvestmentNotification < ActiveRecord::Base
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :budget_investment, :class_name => 'Budget::Investment'

  validates :title, presence: true
  validates :body, presence: true
  validates :budget_investment, presence: true
  # validate :minimum_interval
  #
  # def minimum_interval
  #   return true if proposal.try(:notifications).blank?
  #   if proposal.notifications.last.created_at > (Time.current - Setting[:proposal_notification_minimum_interval_in_days].to_i.days).to_datetime
  #     errors.add(:title, I18n.t('activerecord.errors.models.proposal_notification.attributes.minimum_interval.invalid', interval: Setting[:proposal_notification_minimum_interval_in_days]))
  #   end
  # end

end
