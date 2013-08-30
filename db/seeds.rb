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

#Create feature
features = [
  {
    name: 'Stores',
    description: 'Stores',
    status: true,
    order: 1
  },
  {
    name: 'Users - staff',
    description: 'Users - staff',
    status: true,
    order: 2
  },
  {
    name: '24/7 Appointment Scheduling',
    description: '24/7 Appointment Scheduling',
    status: true,
    order: 3
  },
  {
    name: 'Daily Backups',
    description: 'Daily Backups',
    status: true,
    order: 4
  },
  {
    name: 'Secure HTTPS access',
    description: 'Secure HTTPS access',
    status: true,
    order: 5
  },
  {
    name: 'Export data to CSV',
    description: 'Export data to CSV',
    status: true,
    order: 6
  },
  {
    name: 'Instant Appointment Confirmations',
    description: 'Instant Appointment Confirmations',
    status: true,
    order: 7
  },
  {
    name: 'Email Notifications',
    description: 'Email Notifications',
    status: true,
    order: 8
  },
  {
    name: 'Appointment Scheduling Web Page',
    description: 'Appointment Scheduling Web Page',
    status: true,
    order: 9
  },
  {
    name: 'Offer Unlimited Services',
    description: 'Offer Unlimited Services',
    status: true,
    order: 10
  },
  {
    name: '12 Month Appointment Calendar',
    description: '12 Month Appointment Calendar',
    status: true,
    order: 11
  },
  {
    name: 'Automatic Appointment Reminders',
    description: 'Automatic Appointment Reminders',
    status: true,
    order: 12
  },
  {
    name: 'Mobile/Tablet Web App',
    description: 'Mobile/Tablet Web App',
    status: true,
    order: 13
  },
  {
    name: 'Collect & Promote Reviews',
    description: 'Collect & Promote Reviews',
    status: true,
    order: 14
  },
  {
    name: 'Customer Database & Analytics',
    description: 'Customer Database & Analytics',
    status: true,
    order: 15
  },
  {
    name: 'Customer Support',
    description: 'Customer Support',
    status: true,
    order: 16
  },
  {
    name: 'Individual Staff Logins',
    description: 'Individual Staff Logins',
    status: true,
    order: 17
  },
  {
    name: 'Phone support',
    description: 'Phone support',
    status: true,
    order: 18
  }
]

Feature.create(features)
10.times do |i|
  pricing_plan = PricingPlan.new
  pricing_plan.name = "Plan " + i.to_s
  pricing_plan.description = "Plan description " + i.to_s
  pricing_plan.status = true
  pricing_plan.price_per_month = 100 + i
  pricing_plan.number_of_stores = [1,5,10,100,-2].shuffle.first
  pricing_plan.user_staff = [1,5,10,100,-2].shuffle.first
  pricing_plan.save
end
#create demo data
existed_org_demo = Organization.find_by_name("Organization demo")

if(existed_org_demo.blank?)
  pricing_plan_id = PricingPlan.first().id || 0
  date_now = Date.today
  demo_org =Organization.create(
    :name => "Organization demo",
    :description => "Organization for demo",
    :expired_date => date_now +1.month,
    :state =>"LA",
    :phone =>"",
    :pricing_plan_id => pricing_plan_id
  )
  user_demo = User.new({
    first_name: 'Site',
    last_name: "Demo",
    email: "demo@gmail.com",
    username: "demo",
    password: "123456",
    password_confirmation: "123456",
    is_admin: true,
    organization: demo_org
  })
  user_demo.skip_confirmation!
  user_demo.save
  #create billing report
  BillingReport.create(:user_id =>user_demo.id,:pricing_plan_id => pricing_plan_id,:total_paid =>1000)
  BillingReport.create(:user_id =>user_demo.id,:pricing_plan_id => pricing_plan_id,:total_paid =>10000)
  #Demo2
  demo_org2 =Organization.create(
    :name => "Organization demo2",
    :description => "Organization for demo",
    :expired_date => date_now +1.month,
    :state =>"LA",
    :phone =>"",
    :pricing_plan_id => pricing_plan_id
  )
  user_demo2 = User.new({
    first_name: 'Site',
    last_name: "Demo2",
    email: "demo2@gmail.com",
    username: "demo2",
    password: "123456",
    password_confirmation: "123456",
    is_admin: true,
    organization: demo_org2
  })
  user_demo2.skip_confirmation!
  user_demo2.save
  #create billing report
  BillingReport.create(:user_id =>user_demo2.id,:pricing_plan_id => pricing_plan_id,:total_paid =>200)
  BillingReport.create(:user_id =>user_demo2.id,:pricing_plan_id => pricing_plan_id,:total_paid =>20000)
end
#end create demo 
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