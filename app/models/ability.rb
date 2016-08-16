class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :create, Task, user: user
      can :update, Task, user: user
      can :destroy, Task, user: user
    end
  end
end
