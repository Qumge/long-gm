class Instance < ActiveRecord::Base
  has_paper_trail versions: {
      scope: -> { order("id desc") }
  }
  belongs_to :user
  belongs_to :last_user, foreign_key: :last_user_id, class_name: 'users'
  has_many :instance_logs
  validates_presence_of :name, :instance_no
  has_and_belongs_to_many :products, join_table: 'products_instances'
  validates_uniqueness_of :name, :instance_no


  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  class << self
    def search_conn params
      Instance.all
    end
  end
end
