# This module is used to manager permissions
# History: June 06, 2013
# By NamTV

class Ability
  include CanCan::Ability

  ##
  #Get user list except an user with specify ID
  #Parameters::
  # * (User) *user*: initialize a user with his permissions
  #Return::
  # * (json) Matched user list with paging and number all rows are finded
  #*Author*:: NamTV
  def initialize(user,org_id)

    user ||= User.new # guest user (not logged in)
    # permission view org for any user
    #can :show, Organization, :id => user.organization_id
    can :read, Organization, :id =>  user.organization_id
    can :update_profile, User
    # all permission for super admin
    if user.admin? && user.organization.super_org?
      can :manage, Feature
      can :manage, PricingPlan
      can :update_profile, User
      can :manage, BillingReport
      can :manage, StoreOwner
      return
    end
    # Allow user == admin of group manage User,Group,Log
    if user.admin? && user.organization_id == org_id
      can :manage, User
      can :manage, UserGroup
      can :manage, Review
      can :index, Activity
      can :manage, Appointment
      can :manage, Location
      can :manage, Service
      return
    end
    # Allow user to view, edit himself
    alias_action :read, :update, :to => :manage_self
    #can :manage_self, User, :is_deleted => false, :id => current_user.id

    # check groups is active
    @groups = user.user_groups.where(:is_active => true)
    @permission =[]
    #only set permissions for active groups
    @groups.each do |group|
      @permission.concat(group.permissions)
    end
    # not have duplicated permissions 
    @permission.uniq!

    @permission.each do |p|
      case p.code
      # Add additional ability here
      when "full_organization_management"
        can :manage, Organization
      when "full_group_management"
        can :manage, UserGroup
      when "full_user_management"
        can :manage, User
      when "view_log"
        can :index, Activity
      when "view_organization"
        can [:index, :show], Organization
      when "view_group"
        can [:index, :show], UserGroup
      when "view_user"
        can [:index, :show], User
      end
    end
  end
end
