require_dependency Rails.root.join('app', 'controllers', 'admin/stats_controller').to_s

class Admin::StatsController < Admin::BaseController
  require 'csv'

  def show
    @event_types = Ahoy::Event.group(:name).count

    @visits = Visit.count
    @debates = Debate.with_hidden.count
    @proposals = Proposal.with_hidden.count
    @comments = Comment.with_hidden.count

    @debate_votes = Vote.where(votable_type: 'Debate').count
    @proposal_votes = Vote.where(votable_type: 'Proposal').count
    @comment_votes = Vote.where(votable_type: 'Comment').count
    @votes = Vote.count

    @user_level_two = User.with_hidden.level_two_verified.count
    @user_level_three = User.with_hidden.level_three_verified.count
    @verified_users = User.with_hidden.level_two_or_three_verified.count
    @unverified_users = User.with_hidden.unverified.count
    @users = User.with_hidden.where("email NOT LIKE ?", '%@consul.dev').count
    @user_ids_who_voted_proposals = ActsAsVotable::Vote.where(votable_type: 'Proposal').distinct.count(:voter_id)
    @user_ids_who_didnt_vote_proposals = @verified_users - @user_ids_who_voted_proposals
    @spending_proposals = SpendingProposal.count

    # estadisticas BA Elige
    @total_users = User.where("email NOT LIKE ?", '%@consul.dev').count
    @confirmed_users = User.with_hidden.where("email NOT LIKE ?", '%@consul.dev').where.not(:confirmed_at => nil).count
    @unconfirmed_users = User.with_hidden.where("email NOT LIKE ?", '%@consul.dev').where(:confirmed_at => nil).count
    # etapa de aceptacion
    @users_created_by_gestion = User.with_hidden.where.not(:verified_at => nil).count
    # investment
    budget = Budget.last
    @investments = Budget::Investment.with_hidden.where(:budget_id => budget.id).count
    @investments_count = Budget::Investment.where(:budget_id => budget.id).count
    @investments_per_category = ActsAsTaggableOn::Tag.where("kind = 'category'").order("budget/investments_count" => "DESC").pluck(:name, "budget/investments_count")
    @investments_moderated = Budget::Investment.with_hidden.where(:budget_id => budget.id).where.not(:hidden_at => nil).count
    # newsletter
    @all_users_emails = User.where(newsletter: true).pluck(:email)
    @unconfirmed_users_emails = User.where(:confirmed_at => nil).where("email NOT LIKE ?", '%@consul.dev').where.not(:email => nil).pluck(:email)
    @unconfirmed_users_oath_emails = User.where(:confirmed_at => nil).where("email NOT LIKE ?", '%@consul.dev').where.not(:oauth_email => nil).pluck(:oauth_email)
    @all_unconfirmed = @unconfirmed_users_emails.count + @unconfirmed_users_oath_emails.count
  end

  def csv_investments
    investments = Budget::Investment.all.collect do |investment|
      [
        investment.title,
        investment.id,
        "#{investment.author.username} (#{investment.author.email})",
        investment.summary,
        investment.description.gsub("<p>", "").gsub("</p>", "\n"),
        investment.tag_list.join(", "),
        investment.heading.name,
        investment.total_votes,
        "https://baelige.buenosaires.gob.ar/budgets/1/investments/#{investment.id}"
      ]
    end

    csv_string = CSV.generate(:col_sep => ",", row_sep: "\n") do |csv|
      #header
      csv << ["Título", "ID", "Usuario (email)", "Resumen", "Descripción", "Categorías", "Comuna", "Apoyos", "Link"]
      #content
      investments.each {|investment| csv << investment }
    end

    csv_string.gsub!("\t", "")

    respond_to do |method|
      method.csv { send_data csv_string}
    end
  end

end