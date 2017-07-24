require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s
class Budget
  class Investment < ActiveRecord::Base

    include Flaggable
    include Conflictable

    has_many :custom_budget_investment_notifications, :class_name => 'Custom::BudgetInvestmentNotification'

    validates :summary, presence: true
    validates :tag_list, presence: true

    scope :sort_by_created_at,       -> { reorder(created_at: :desc) }
    scope :sort_by_most_commented,   -> { reorder(comments_count: :desc) }
    scope :sort_by_flags,            -> { order(flags_count: :desc, updated_at: :desc) }
    scope :with_ignored_flag,        -> { where.not(ignored_flag_at: nil).where(hidden_at: nil) }
    scope :without_ignored_flag,      -> { where(ignored_flag_at: nil) }

    def searchable_values
      { title              => 'A',
        author.username    => 'B',
        heading.try(:name) => 'B',
        tag_list.join(' ') => 'B',
        description        => 'C',
        summary            => 'D',
      }
    end

    def self.for_summary
      summary = {}
      categories = ActsAsTaggableOn::Tag.category_names.sort
      geozones   = Geozone.names.sort

      groups = categories + geozones
      groups.each do |group|
        summary[group] = search(group).last_week.sort_by_confidence_score.limit(3)
      end
      summary
    end

    def self.apply_filters_and_search(budget, params)
      investments = all
      if budget.balloting? && params[:heading_id].present?
        investments = investments.selected
      else
        investments = investments.unfeasible if params[:unfeasible].present?
      end
      investments = investments.by_heading(params[:heading_id]) if params[:heading_id].present?
      investments = investments.search(params[:search])         if params[:search].present?
      investments
    end

    def should_show_aside?
      (budget.selecting?  && !unfeasible?) ||
      (budget.balloting?  && feasible?)    ||
      (budget.valuating?)
    end

    def editable_by?(user)
      author_id == user.id && editable?
    end

    def valuable_by?(user)
      valuator = Valuator.where(user_id: user.id)
      !self.valuator_assignments.where(valuator_id: valuator.first.id).empty? unless valuator.empty?
    end

    def editable?
      self.budget.accepting?
    end

    def notifications
      custom_budget_investment_notifications
    end

  end
end
