# == Schema Information
#
# Table name: resources
#
#  id         :integer          not null, primary key
#  action     :string(255)
#  target     :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Resource < ActiveRecord::Base
  has_and_belongs_to_many :roles, join_table: 'role_resources'

  def self.load!
    config = YAML.load_file("#{Rails.root}/config/resources.yml")
    config.each do |target, value|
      value.each do |action, name|
        Resource.find_or_create_by action: action, name: name, target: target
      end
    end
  end
end
