# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  login                  :string(255)
#  name                   :string(255)
#  role_id                :integer
#  organization_id        :integer
#  phone                  :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # has_paper_trail
  belongs_to :role
  belongs_to :organization
  has_and_belongs_to_many :instances, join_table: 'instances_users'
  has_and_belongs_to_many :products, join_table: 'products_users'
  has_many :develop_instance_logs, foreign_key: :develop_id, class_name: 'InstanceLog'
  has_many :flow_instance_logs, foreign_key: :flow_id, class_name: 'InstanceLog'
  has_many :active_instance_logs, foreign_key: :active_id, class_name: 'InstanceLog'

  has_many :develop_product_logs, foreign_key: :develop_id, class_name: 'ProductLog'
  has_many :flow_product_logs, foreign_key: :flow_id, class_name: 'ProductLog'
  has_many :active_product_logs, foreign_key: :active_id, class_name: 'ProductLog'

  has_many :develop_technology_logs, foreign_key: :develop_id, class_name: 'TechnologyLog'
  has_many :flow_technology_logs, foreign_key: :flow_id, class_name: 'TechnologyLog'
  has_many :active_technology_logs, foreign_key: :active_id, class_name: 'TechnologyLog'

  has_many :instance_logs
  has_many :product_logs
  has_many :technology_logs
  has_many :user_notices
  has_many :send_notices, class_name: 'Notice'
  has_and_belongs_to_many :notices, join_table: 'user_notices'

  has_many :matters

  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :validatable


  def audit_users action, target
    User.joins(role: :resources).where('resources.target = ? and resources.action = ?  and users.id != ?', target, "do_#{action}_audit", self.id)
  end

  def has_role? role
    self.role.present? && self.role.desc == role
  end

  def user_notice notice
    user_notices.find_by notice: notice
  end

  def resources
    role&.resources
  end

  def has_product_log_resource?
    self.has_role?('super_admin') || (self.role.present? && self.role.resources.find_by(name: '产品-所有文件记录'))
  end


  def has_instance_log_resource?
    self.has_role?('super_admin') || (self.role.present? && self.role.resources.find_by(name: '零件-所有文件记录'))
  end

  def has_technology_log_resource?
    self.has_role?('super_admin') || (self.role.present? && self.role.resources.find_by(name: '工艺文件-所有文件记录'))
  end


  #未读消息
  def unread_notices
    self.user_notices.where('readed = 0 or readed is null')
  end

  #未回复消息
  def unreply_notices
    self.user_notices.joins(:notice).where('notices.need_reply = 1 and (user_notices.replied = 0 or user_notices.replied is null)')
  end

  #单发通知
  def user_send_notice user, title, content, model
    notice = Notice.create model_type: model.class.name, model_id: model.id, content: content, title: title, user: self
    UserNotice.create user: user, notice: notice
  end

  # 群发通知
  def user_send_notices users, title, content, model
    notice = Notice.create model_type: model.class.name, model_id: model.id, content: content, title: title, user: self
    users.each do |u|
      UserNotice.create user: u, notice: notice
    end
  end

  #发送流转通知
  def send_bom_notice user, model
    content = "#{user.name}:
您好!
  Bom单【#{model.name}】已经进入下一流程，请及时处理！
"
    self.user_send_notice user, 'Bom流转通知', content, model
  end

  #发送会签通知
  def send_countersign_notice users, model
    content = "您好!
  Bom单【#{model.name}】已经发起会签，请及时处理！
"
    self.user_send_notices users, 'Bom会签通知', content, model
  end

  # 可查看商品
  def view_products
    products = self.products
    if self.organization.present?
      ids = self.organization.ancestor_ids
      ids << self.organization.id
      products = Product.left_join(:organizations, :users).where('organizations.id in (?) or users.id = ?', ids, self.id)
    end
    products.uniq
  end

  # 可见
  def can_view? model
    if model.class.name == 'Product'
      view_products.include? model
    elsif model.class.name == 'Instance'
      view_instances.include? model
    else
      false
    end
  end

  # 可查看零件
  def view_instances
    instances = self.instances
    if self.organization.present?
      ids = self.organization.ancestor_ids
      ids << self.organization.id
      instances = Instance.left_join(:organizations, :users).where('organizations.id in (?) or users.id = ?', ids, self.id)
    end
    instances.uniq
  end

end
