# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: :regular)

    if user.admin?
      can :manage, :all
    else
      can :read, Recipe
      can :create, Recipe

      can [ :update, :destroy ], Recipe, user_id: user.id
    end
  end
end
