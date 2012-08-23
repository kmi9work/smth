class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role >= 0
      can :search, :all
      can :read, :all
    end
    if user.role >= 1 #Registered
      # can :read, Article
      # can :read, Comment
      # can :read, Criterion
      # can :read, Filter
      # can :read, User
      # can :read, Rating
      
      can :create, Article #KARMA HERE !!!
      can :manage, Article, user_id: user.id
      
      can :create, Comment #KARMA HERE !!!
      can :destroy, Comment, user_id: user.id #how to destroy in right way? Saving other comments... ???????????????
      
      can :manage, User, id: user.id
      
    end
    if user.role >= 2 #Trusted
      puts "22222222222"
      can :create, Article #WITHOUT KARMA
      can :create, Comment #WITHOUT KARMA
    end
    if user.role >= 3 #Moderator
      can :destroy, Article
      can :destroy, Comment
      can :manage, Criterion
    end
    if user.role >= 4 #Admin
      can :manage, :all
    end
    # Define abilities for the passed in user here. For example:
    #
    #   
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
