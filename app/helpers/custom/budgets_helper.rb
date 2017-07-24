require_dependency Rails.root.join('app', 'helpers', 'budgets_helper').to_s

module Custom::BudgetsHelper

  # created for BAELIGE
  def budget_invesments_tags_select_options
    ActsAsTaggableOn::Tag.where('taggings.taggable_type' => 'Budget::Investment').includes(:taggings).order(:name).uniq
  end

end