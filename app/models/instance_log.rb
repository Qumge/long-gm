class InstanceLog < ActiveRecord::Base
  belongs_to :instance
  belongs_to :user


  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  def get_status
    self.status
  end

end
