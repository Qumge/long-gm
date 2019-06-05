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
  include FileConcern
  has_paper_trail versions: {
      scope: -> { order("id desc") }
  }
  has_many :notices, -> {where(model_type: 'Product')}, class_name: 'Notice', foreign_key: :model_id
  belongs_to :user
  belongs_to :last_user, foreign_key: :last_user_id, class_name: 'User'
  belongs_to :file_user, foreign_key: :file_user_id, class_name: 'User'
  has_many :product_logs
  has_many :products_instances
  belongs_to :technology
  validates_presence_of :name, :product_no
  has_and_belongs_to_many :instances, join_table: 'products_instances'
  has_and_belongs_to_many :organizations, join_table: 'product_organizations'
  has_and_belongs_to_many :users, join_table: 'products_users'
  validates_uniqueness_of :name, :product_no

  # after_save :do_stp2_stl


  def view_logs user
    if user.has_product_log_resource?
      self.product_logs
    else
      self.product_logs.where(user: user)
    end
  end

  def get_model_name
    '产品'
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

    def get_model_name
      '产品'
    end


    def format_files files, develop_id, flow_id, active_id, user
      reg = /\((.+?)\)/
      files.each do |key, value|
        no = value.match(reg)[1]
        product = Product.find_by product_no: no
        if product.present?
          ProductLog.create file_name: value,file_path: key, product: product, user: user, status: :apply, apply_at: DateTime.now, develop_id: develop_id, flow_id: flow_id, active_id: active_id
        else
          instance = Instance.find_by instance_no: no
          if instance.present?
            InstanceLog.create file_name: value,file_path: key, instance: instance, user: user, status: :apply, apply_at: DateTime.now, develop_id: develop_id, flow_id: flow_id, active_id: active_id
          end
        end
      end
    end
  end

end
