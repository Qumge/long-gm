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
  has_paper_trail versions: {
      scope: -> { order("id desc") }
  }
  belongs_to :user
  belongs_to :last_user, foreign_key: :last_user_id, class_name: 'users'
  has_many :product_logs
  validates_presence_of :name, :product_no
  has_and_belongs_to_many :instances, join_table: 'products_instances'
  validates_uniqueness_of :name, :product_no


  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  class << self
    def search_conn params
      Product.all
    end
  end

end
