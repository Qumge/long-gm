# == Schema Information
#
# Table name: product_logs
#
#  id         :integer          not null, primary key
#  product_id :integer
#  file_name  :string(255)
#  file_path  :string(255)
#  user_id    :integer
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :product


  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  def get_status
    self.status
  end
end
