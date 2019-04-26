class Attachment < ActiveRecord::Base
  def preview_url
    Rails.application.config.qiniu_domain + '/' + path if path.present?
  end
end
