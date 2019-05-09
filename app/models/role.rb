# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  desc       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  has_many :role_resources
  has_and_belongs_to_many :resources, join_table: 'role_resources'
  ROLES = {super_admin: '超级管理员', develop_manager: '研发管理', developer: '研发', processer: '流程管理'}

  class << self
    def load!
      ROLES.each do |key, value|
        Role.create name: value, desc: key unless Role.find_by(desc: key).present?
      end
    end
  end
end
