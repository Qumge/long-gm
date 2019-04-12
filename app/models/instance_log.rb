class InstanceLog < ActiveRecord::Base
  include AASM
  belongs_to :instance
  belongs_to :user

  STATUS = {wait: '草稿', apply: '申请中', developer: '技术已审批', flow: '流程化', active: '申请成功', failed: '申请失败'}

  aasm :status do
    state :wait, :initial => true
    state :apply, :develop, :flow, :active, :failed

    event :do_apply do
      transitions :from => [:wait, :failed], :to => :apply, :after => Proc.new {after_apply}
    end
    event :do_develop_audit do
      transitions :from => :apply, :to => :develop, :after => Proc.new {after_develop }
    end
    event :do_flow_audit do
      transitions :from => :develop, :to => :flow, :after => Proc.new { after_flow }
    end
    event :do_active_audit do
      transitions :from => :flow, :to => :active, :after => Proc.new { after_active}
    end
    event :do_failed_audit do
      transitions :from => [:apply, :developer, :flow], :to => :failed, :after => Proc.new { after_failed}
    end
  end

  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  def get_status
    InstanceLog::STATUS[self.status.to_sym] if self.status.present?
  end

  def after_apply

  end

  def after_develop

  end

  def after_flow

  end

  def after_active

  end

  def after_failed

  end

end
