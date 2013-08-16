# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

if Permission.count == 0
  permissions = [{
    :name => "Full Access on Organization Management",
    :code => "full_organization_management",
    :group_permission_name => "Manage Organizations"
  },{
    :name => "Full Access on Functional User Group",
    :code => "full_group_management",
    :group_permission_name => "Manage User Groups"
  },{
    :name => "Full Access on User Management",
    :code => "full_user_management",
    :group_permission_name => "Manage Users"
  },{
    :name => "View Log",
    :code => "view_log",
    :group_permission_name => "Manage Logs"
  },{
    :name => "View List of Organization(s)",
    :code => "view_organization",
    :group_permission_name => "Manage Organizations"
  },{
    :name => "View  User Group",
    :code => "view_group",
    :group_permission_name => "Manage User Groups"
  },{
    :name => "View User",
    :code => "view_user",
    :group_permission_name => "Manage Users"
  }]

  permissions = Permission.create(permissions)
end

if Organization.count == 0
  admin_org = Organization.create(
    name: "Super Organization",
    description: "Organization for admin"
  )
  admin_org.is_super_org = true
  admin_org.save
end

if UserGroup.count == 0
  group = UserGroup.create({
    name:"Administrator",
    permissions: permissions,
    organization: admin_org
  })
end

if User.count == 0
  created_user = User.new({
    first_name: 'Site',
    last_name: "Administrator",
    email: "admin@gmail.com",
    username: "admin",
    password: "123456",
    password_confirmation: "123456",
    is_admin: true,
    user_groups: [group],
    organization: admin_org
  })
  created_user.skip_confirmation!
  created_user.save
end

if ENV['RAILS_ENV'] == "test"
  user_mgt_group = UserGroup.create({
    name: "Manage User",
    permissions: [Permission.find_by_code("user_management")]
  })

  group_mgt_group = UserGroup.create({
    name: "Manage Group",
    permissions: [Permission.find_by_code("group_management")]
  })

  none_group = UserGroup.create({
    name: "None Group"
  })

  users = [{
    first_name: 'Test',
    last_name: 'Test',
    username: 'mgt_user',
    password: '1qazxsw2',
    password_confirmation: "1qazxsw2",
    user_groups: [user_mgt_group]
  },{
    first_name: 'Test',
    last_name: 'Test',
    username: 'mgt_group',
    password: '1qazxsw2',
    password_confirmation: "1qazxsw2",
    user_groups: [group_mgt_group]
  },{
    first_name: 'Test',
    last_name: 'Test',
    username: 'mgt_none',
    password: '1qazxsw2',
    password_confirmation: "1qazxsw2",
    user_groups: [none_group]
  }]

  User.create(users)
end