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
  has_and_belongs_to_many :instances, join_table: 'instances_users'
  has_and_belongs_to_many :products, join_table: 'products_users'
  has_many :instance_logs
  has_many :product_logs
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :validatable


  def has_role? role
    true
  end

  def resources
    role&.resources
  end

  def has_product_log_resource?
    self.role.present? && self.role.resources.find_by(name: '产品-所有文件记录')
  end

  def has_instance_log_resource?
    self.role.present? && self.role.resources.find_by(name: '零件-所有文件记录')
  end
end
