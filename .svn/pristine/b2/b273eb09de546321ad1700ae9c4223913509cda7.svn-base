# This model is used to comunicate with table permission in database
# This model is used to comunicate with table permission in database
# History: June 06, 2013
# By NamTV

class Permission < ActiveRecord::Base
  attr_accessible :name, :code, :group_permission_name
  has_many :user_groups_permissions, :dependent => :destroy

  def self.get_group_permissions
    Permission.select(:group_permission_name).uniq
  end

  def self.get_permission_in_group_permission(name)
    Permission.select("id, name").where(:group_permission_name => name )
  end

  def self.get_hash_group_permission
    permissions = {}
    group_permissions = Permission.select(:group_permission_name).uniq
    group_permissions.each do |gp|
      permissions[gp.group_permission_name] =  Permission.select("id, name").where(:group_permission_name => gp.group_permission_name)
    end
    return permissions
  end

end