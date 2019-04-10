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
  has_and_belongs_to_many :users, join_table: 'products_users'
  validates_uniqueness_of :name, :product_no


  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  def view_logs user
    if user.has_product_log_resource?
      self.product_logs
    else
      self.product_logs.where(user: user)
    end
  end

  class << self
    def search_conn params
      products = Product.joins(:user).all
      if params[:table_search].present?
        products = products.where('products.product_no like ? or products.name like ? or products.norms like ? or users.name like ?',
                                  "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%",
                                  "%#{params[:table_search]}%")
      end
      products
    end
  end

end
