class AuditsController < ApplicationController

  def index

  end

  def products
    @apply_product_logs = ProductLog.where(status: 'apply').order('product_logs.updated_at desc')
    @develop_product_logs = ProductLog.where(status: 'develop').order('product_logs.updated_at desc')
    @flow_product_logs = ProductLog.where(status: 'flow').order('product_logs.updated_at desc')
  end

  def instances
    @apply_instance_logs = InstanceLog.where(status: 'apply').order('instance_logs.updated_at desc')
    @develop_instance_logs = InstanceLog.where(status: 'develop').order('instance_logs.updated_at desc')
    @flow_instance_logs = InstanceLog.where(status: 'flow').order('instance_logs.updated_at desc')
  end

end
