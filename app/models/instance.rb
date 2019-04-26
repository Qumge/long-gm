class Instance < ActiveRecord::Base
  has_paper_trail versions: {
      scope: -> { order("id desc") }
  }
  belongs_to :user
  belongs_to :last_user, foreign_key: :last_user_id, class_name: 'users'
  belongs_to :file_user, foreign_key: :file_user_id, class_name: 'users'
  has_many :instance_logs
  validates_presence_of :name, :instance_no
  has_and_belongs_to_many :products, join_table: 'products_instances'
  has_and_belongs_to_many :users, join_table: 'instances_users'
  validates_uniqueness_of :name, :instance_no
  has_and_belongs_to_many :technologies, join_table: 'technology_instances'

  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  def view_logs user
    if user.has_instance_log_resource?
      self.instance_logs
    else
      self.instance_logs.where(user: user)
    end
  end

  class << self
    def search_conn params
      instances = Instance.joins(:user).all
      if params[:table_search].present?
        instances = instances.where('instances.instance_no like ? or instances.name like ? or instances.norms like ? or users.name like ?',
                                  "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%",
                                  "%#{params[:table_search]}%")
      end
      instances
    end
  end
end
