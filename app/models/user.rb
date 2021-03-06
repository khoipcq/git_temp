# This model is used to comunicate with table User in database
# History: June 06, 2013
# By NamTV

class User < ActiveRecord::Base

  # List attributes need to be log
  LOG_ATTRS = ["first_name", "last_name", "username", "email", "is_deleted", "password", "current_sign_in_at", "user_groups", "user_group_ids", "encrypted_password"]

  # Use to log actions
  include PublicActivity::Common
  after_update :after_update_user
  after_create :after_create_user
  before_destroy :before_destroy_user

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :async

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :first_name,:last_name, :email, :is_deleted, :password, :password_confirmation, :remember_me, :last_sign_in_at, :last_sign_out_at, :current_sign_in_at, :user_groups, :user_group_ids, :is_admin, :organization, :organization_id
  # validates :username, :uniqueness => true
  validates :email, :uniqueness => true

  # attr_accessible :title, :body
  validates :first_name, :presence => true, :length => {:minimum => 2}
  validates :last_name, :presence => true, :length => {:minimum => 2}

  has_many :user_groups_users, :dependent => :destroy
  has_many :user_groups, :through => :user_groups_users
  has_one :billing_card_info
  has_many :appointments, foreign_key: "staff_id"
  has_many :appointments, foreign_key: "customer_id"

  # Relationship with organization
  belongs_to :organization

  #accepts_nested_attributes_for :user_group_user, allow_destroy: true

  scope :not_in_user_group, lambda {|except_ids| where("id NOT IN ( ? ) ", except_ids )}
  scope :id_not, lambda { |except_id| where("id != ?", except_id) }
  scope :in_organization, lambda { |id| where(organization_id: id) }
  scope :active, where(:is_deleted => false)
  scope :not_admin, where(:is_admin => false)
  scope :search_full_name, lambda { |search| where("lower(concat(first_name, ' ', last_name)) like ?", "%" + search + "%") }
  ##
  #Get user list except an user with specify ID
  #Parameters::
  # * (Integer) *id*: id want to be ignored
  # * (Integer) *page*: current page
  # * (Integer) *per_page*: items amount per page
  # * (String) *search*: search string
  # * (String) *sort*: name of sorted column
  #Return::
  # * (Array) Matched user list with paging
  #*Author*:: NamTV
  def self.get_all_users_except_id(id, page, per_page, search, sort = nil,organizatiaon_id)
    sort ||= "full_name"
    search = search.downcase
    users = not_admin.in_organization(organization_id).id_not(id).select("id, concat(first_name, ' ', last_name) as full_name, username, is_deleted")

    users = users.search_full_name(search) if !search.blank?

    return_data = {
      "aaData" => [],
      "iTotalDisplayRecords" => users.count
    }
    users = users.order(sort).paginate(:page => page, :per_page => per_page)
    no = per_page.to_i * (page.to_i-1) + 1
    users.each do |user|
      return_data["aaData"] << [
        no,
        user.full_name,
        user.username,
        user.is_deleted,
        "",
        user.id
      ]
      no += 1
    end
    return return_data
  end

  ##
  #Return ::
  # * (String) check if user is active or not
  #*Author*:: NamTV
  def active_for_authentication?
   super && !self.organization.is_stopped
  end

  ##
  #Return::
  # * (Boolean) check if user is admin or not
  #*Author*:: NamTV
  def admin?
    self.is_admin
  end

  ##
  #Return::
  # * (String) full name
  #*Author*:: NamTV
  def user_full_name
    [first_name, last_name].join(" ")
  end

  protected

  ##
  #Return::
  # * (Boolean) email required?
  #*Author*:: NamTV
  def email_required?
    false
  end

  ##
  # Write logs after update user
  #*Author*:: NamTV
  def after_update_user

    not_need_log = (self.changed.select {|attr| LOG_ATTRS.include?(attr)}).blank?
    puts "vao after user"
    controller = PublicActivity.get_controller
    # return if nothing changed or
    return if !controller || self.changed.blank? || not_need_log
    puts "vao after user2 "
    current_user = PublicActivity.get_controller.current_user
    puts current_user.inspect
    return if !current_user

    # if self.current_sign_in_at_changed?
    #   # self.create_activity :login, owner: current_user, organization_id: current_user.organization_id , params: {:detail => I18n.t('logs.login')}
    # elsif self.id == current_user.id
    #   # self.create_activity :update, owner: current_user, organization_id: current_user.organization_id, params: {:detail => I18n.t('logs.update_profile')}
    # else
    #   # self.create_activity :edit_info, owner: current_user,  organization_id: self.organization_id , params: {:detail => I18n.t('logs.edit_user', user_name: self.username)}
    # end
  end

  ##
  # Write logs after create user
  #*Author*:: NamTV
  def after_create_user
    controller = PublicActivity.get_controller
    return if !controller
    current_user = PublicActivity.get_controller.current_user
    return if current_user.blank?
    if current_user
      self.create_activity :add, owner: current_user,organization_id: self.organization_id, params: {:detail => I18n.t('logs.create_user', user_name: self.username)}
    else
      self.create_activity :register, owner: self, organization_id: self.organization_id, params: {:detail => I18n.t('logs.register')}
    end
  end

  ##
  # Write logs before remove user
  #*Author*:: NamTV
  def before_destroy_user
    controller = PublicActivity.get_controller
    return if !controller
    current_user = PublicActivity.get_controller.current_user
    update_deleted_name
    self.create_activity :delete, owner: current_user, organization_id: self.organization_id, params: {:detail => I18n.t('logs.delete_user', user_name: self.username)}
  end

  def update_deleted_name
    puts "vao delete"
      logs = Activity.where(:owner_id => self.id)
      logs.update_all(:deleted_name => self.username)
  end
end
