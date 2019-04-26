class Notice < ActiveRecord::Base
  has_many :user_notices
  belongs_to :user
  has_and_belongs_to_many :users, join_table: 'user_notices'
  scope :initiative_notices, ->{where(model_type: 'User')}
  has_one :file, -> {where(model_type: 'Notice')}, class_name: 'Attachment', foreign_key: :model_id
  validates_presence_of :title, :content


  class << self
    def search_conn params
      if params[:table_search].present?
        self.joins(:user).where('users.name like ? or notices.content like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      else
        self.all
      end
    end
  end

  def user_notice user
    user_notices.find_by user: user
  end

  def replied_users
    user_notices.where(replied: true)
  end

  def readed_users
    user_notices.where(readed: true)
  end

  def sub_content
    content.size > 20 ? "#{content[0, 19]}..." : content
  end


end
