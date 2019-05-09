class InstancesController < ApplicationController
  before_action :set_instance, only: [:show, :edit, :update, :destroy, :show_version, :upload_file, :do_upload_file]
  before_action :set_uptoken, only: [:upload_file, :edit_file]
  before_action :set_log, only: [:edit_file, :update_file, :apply]
  before_action :set_audit_log, only: [:do_develop_audit, :do_flow_audit, :do_active_audit, :do_failed_audit]
  include ApplicationHelper
  def index
    @instances = Instance.search_conn(params).page(params[:page]).per(Settings.per_page)
  end

  def new
    @instance = Instance.new
    render layout: false
  end

  def create
    @instance = Instance.new
    @instance.user = current_user
    @flag = @instance.update instance_permit
  end

  def show

  end

  def edit
    render layout: false
  end

  def update
    @flag = @instance.update instance_permit
  end

  def destroy
    if @instance.destroy
      redirect_to instances_path, notice: '删除成功'
    else
      redirect_to instances_path, alert: '删除失败'
    end
  end

  def upload_file
    render layout: false
  end

  def do_upload_file
    InstanceLog.create instance: @instance, file_path: params[:path], file_name: params[:file_name], user: current_user
    render js: 'location.reload()'
  end

  def show_version
    @version = @instance.versions.find_by id: params[:version_id]
    render layout: false
  end

  def apply
    @instance = @log.instance
    begin
      @log.do_apply!
      @flag = true
    rescue => e
      @flag = false
    end
  end

  def edit_file
    render layout: false
  end

  def update_file
    @instance = @log.instance
    @flag = @log.update file_path: params[:path], file_name: params[:file_name]
  end

  def do_develop_audit
    begin
      from_status = @log.status
      @log.do_develop_audit!
      @log.audits.create from_status: from_status, to_status: @log.status, user: current_user
      @flag = true
    rescue => e
      @flag = false
    end
    render js: 'location.reload()'
  end

  def do_flow_audit
    begin
      from_status = @log.status
      @log.do_flow_audit!
      @log.audits.create from_status: from_status, to_status: @log.status, user: current_user
      @flag = true
    rescue => e
      @flag = false
    end
    render js: 'location.reload()'
  end

  def do_active_audit
    begin
      from_status = @log.status
      @log.do_active_audit!
      @log.audits.create from_status: from_status, to_status: @log.status, user: current_user
      @flag = true
    rescue => e
      @flag = false
    end
    render js: 'location.reload()'
  end

  def do_failed_audit
    begin
      from_status = @log.status
      @log.do_failed_audit!
      @log.audits.create from_status: from_status, to_status: @log.status, user: current_user
      @flag = true
    rescue => e
      @flag = false
    end
    render js: 'location.reload()'
  end

  private

  def instance_permit
    params.require('instance').permit(:instance_no, :name, :norms, :desc, user_ids: [])
  end

  def set_instance
    @instance = Instance.find_by id: params[:id]
    redirect_to instances_path, alert: '找不到数据' unless @instance.present?
  end

  def set_log
    @log = current_user.instance_logs.find_by id: params[:id]
    redirect_to instances_path, alert: '找不到数据' unless @log.present?
  end

  def set_audit_log
    @log = InstanceLog.find_by id: params[:id]
    redirect_to instances_path, alert: '找不到数据' unless @log.present?
  end

  def set_uptoken
    @uptoken = uptoken
  end
end
