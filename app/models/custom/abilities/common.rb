require_dependency Rails.root.join('app', 'models', 'abilities', 'common').to_s

module Abilities
  class Common
    include CanCan::Ability

    def initialize(user)
      self.merge Abilities::Everyone.new(user)

      can [:read, :update], User, id: user.id

      can :read, Debate
      can :update, Debate do |debate|
        debate.editable_by?(user)
      end

      can :read, Proposal
      can :update, Proposal do |proposal|
        proposal.editable_by?(user)
      end
      can [:retire_form, :retire], Proposal, author_id: user.id

      can :create, Comment
      can :create, Debate
      can :create, Proposal

      can :suggest, Debate
      can :suggest, Proposal

      can [:flag, :unflag], Comment
      cannot [:flag, :unflag], Comment, user_id: user.id

      can [:flag, :unflag], Debate
      cannot [:flag, :unflag], Debate, author_id: user.id

      can [:flag, :unflag], Proposal
      cannot [:flag, :unflag], Proposal, author_id: user.id

      unless user.organization?
        can :vote, Debate
        can :vote, Comment
      end

      can :vote,   Budget::Investment,               budget: { phase: "selecting" }
      can :create, Budget::Investment,               budget: { phase: "accepting" }
      can :edit,  Budget::Investment,                budget: { phase: "accepting" }
      can :update,  Budget::Investment,                budget: { phase: "accepting" }

      if user.level_two_or_three_verified?
        can :vote, Proposal
        can :vote_featured, Proposal
        can :vote, SpendingProposal
        can :create, SpendingProposal

        can [:show, :create], Budget::Ballot,          budget: { phase: "balloting" }
        can [:create, :destroy], Budget::Ballot::Line, budget: { phase: "balloting" }

        can :create, DirectMessage
        can :show, DirectMessage, sender_id: user.id
      end

      can [:create, :show], ProposalNotification, proposal: { author_id: user.id }
      can [:create, :show], BudgetInvestmentNotification, budget_investment: { author_id: user.id }

      can :create, Annotation
      can [:update, :destroy], Annotation, user_id: user.id
    end
  end
end
