require_dependency Rails.root.join('app', 'models', 'user').to_s

class User < ActiveRecord::Base

  scope :by_email,       -> (email) { where(email: email) }

  def block
    debates_ids = Debate.where(author_id: id).pluck(:id)
    comments_ids = Comment.where(user_id: id).pluck(:id)
    proposal_ids = Proposal.where(author_id: id).pluck(:id)
    budget_investments_ids = Budget::Investment.where(author_id: id).pluck(:id)

    self.hide

    Debate.hide_all debates_ids
    Comment.hide_all comments_ids
    Proposal.hide_all proposal_ids
    Budget::Investment.hide_all budget_investments_ids
  end

end
