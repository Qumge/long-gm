# == Schema Information
#
# Table name: product_logs
#
#  id         :integer          not null, primary key
#  product_id :integer
#  file_name  :string(255)
#  file_path  :string(255)
#  user_id    :integer
#  status     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductLog < ActiveRecord::Base
  include AASM
  belongs_to :user
  belongs_to :product
  has_many :audits, -> {where(model_type: 'ProductLog')}, foreign_key: :model_id

  STATUS = {wait: '草稿', apply: '申请中', develop: '技术已审批', flow: '流程化', active: '申请成功', failed: '申请失败'}

  aasm :status do
    state :wait, :initial => true
    state :apply, :develop, :flow, :active, :failed

    event :do_apply do
      transitions :from => [:wait, :failed], :to => :apply, :after => Proc.new {after_apply }
    end
    event :do_develop_audit do
      transitions :from => :apply, :to => :develop, :after => Proc.new {after_develop }
    end
    event :do_flow_audit do
      transitions :from => :develop, :to => :flow, :after => Proc.new {after_flow }
    end
    event :do_active_audit do
      transitions :from => :flow, :to => :active, :after => Proc.new {after_active}
    end
    event :do_failed_audit do
      transitions :from => [:apply, :develop, :flow], :to => :failed, :after => Proc.new {after_failed }
    end
  end

  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  def get_status
    ProductLog::STATUS[self.status.to_sym] if self.status.present?
  end

  def after_apply
    self.update apply_at: DateTime.now
  end

  def after_develop

  end

  def after_flow

  end

  def after_active
    self.update active_at: DateTime.now
    self.product.update file_path: self.file_path, file_name: self.file_name, active_at: DateTime.now, file_user: self.user
  end

  def after_failed

  end
end
