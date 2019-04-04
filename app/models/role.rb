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

end
