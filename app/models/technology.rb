class Technology < ActiveRecord::Base
  has_and_belongs_to_many :instances, join_table: 'technology_instances'
  belongs_to :user
  validates_uniqueness_of :name, :no
  validates_presence_of :name, :no
  has_many :technology_instances, dependent: :destroy

  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  def get_model_name
    '工艺文件'
  end


  class << self
    def search_conn params
      technologies = Technology.joins(:user).all
      if params[:table_search].present?
        technologies = technologies.where('technologies.no like ? or technologies.name like ? or users.name like ?',
                                    "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      technologies
    end
  end

end
