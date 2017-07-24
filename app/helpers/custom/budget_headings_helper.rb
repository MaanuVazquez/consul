require_dependency Rails.root.join('app', 'helpers', 'budget_headings_helper').to_s

module Custom::BudgetHeadingsHelper

  def budget_heading_select_options(budget)
    budget.headings.order(:id).map do |heading|
      [heading.name, heading.id]
    end
  end

  def budget_categories(categories)
    categories.each do |category|
      [category.name, category.id]
    end
  end

  def get_heading_id_from_name(group, heading_name)
    headings = Hash[group.headings.map{|i| [i.name, i.id]} ]
    headings[heading_name]
  end

end
