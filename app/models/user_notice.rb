class UserNotice < ActiveRecord::Base
  belongs_to :notice
  belongs_to :user
  class << self
    def search_conn params
      if params[:table_search].present?
        self.joins(notice: :user).where('users.name like ? or notices.title like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      else
        self.all
      end
    end
  end

end
