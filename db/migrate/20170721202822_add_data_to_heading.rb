class AddDataToHeading < ActiveRecord::Migration
  def change
    add_column :budget_headings, :padron, :text
    add_column :budget_headings, :ingreso_promedio, :text
    add_column :budget_headings, :pct_ingreso_inverso, :text
    add_column :budget_headings, :pct_habitante, :text
  end
end
