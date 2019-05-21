class UserMatter < ActiveRecord::Base
  belongs_to :user
  belongs_to :matter
  after_update :check_agree

  def format_agree
    case self.agree
    when true
      '已确认'
      when false
      '失败'
    else
      '待确认'
    end
  end

  def check_agree
    if self.agree
      self.matter.check_agree
    end
  end
end
