# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  category_id  :integer
#  name         :string(255)
#  product_no   :string(255)
#  color        :string(255)
#  norms        :string(255)
#  file_name    :string(255)
#  file_path    :string(255)
#  desc         :text(65535)
#  user_id      :integer
#  last_user_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Product < ActiveRecord::Base
  has_paper_trail
end
