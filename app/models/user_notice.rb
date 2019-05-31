class UserNotice < ActiveRecord::Base
  belongs_to :notice
  belongs_to :user
  class << self
    def search_conn params
      if params[:table_search].present?
        if params[:table_search] == '未读'
          user_notices = self.joins(notice: :user).where('readed is null or readed = 0')
        elsif params[:table_search] == '已读'
          user_notices = self.joins(notice: :user).where(readed: 1)
        elsif params[:table_search] == '未回复'
          user_notices = self.joins(notice: :user).where('notices.need_reply = 1').where('replied is null or readed = 0')
        elsif params[:table_search] == '已回复'
          user_notices = self.joins(notice: :user).where('notices.need_reply = 1').where(replied: 1)
        else
          user_notices = self.joins(notice: :user).where('users.name like ? or notices.title like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
        end
      else
        self.all
      end
    end

  end


end
