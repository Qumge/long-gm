class TechnologiesController < ApplicationController
  include ApplicationHelper
  before_action :set_technology, only: [:show, :edit, :update, :destroy, :show_version, :upload_file, :do_upload_file]
  before_action :set_uptoken, only: [:upload_file, :edit_file]
  before_action :set_log, only: [:edit_file, :update_file, :apply, :do_apply]
  before_action :set_audit_log, only: [:do_develop_audit, :do_flow_audit, :do_active_audit, :do_failed_audit]
  def index
    @technologies = Technology.search_conn(params).order('updated_at desc').page(params[:page]).per(Settings.per_page)
  end

  def new
    @technology = Technology.new
    render layout: false
  end

  def create
    @technology = Technology.new
    @technology.user = current_user
    @flag = @technology.update technology_permit
  end

  def show

  end

  def edit
    render layout: false
  end

  def update
    @flag = @technology.update technology_permit
  end

  def destroy
    if @technology.destroy
      redirect_to technologies_path, notice: '删除成功'
    else
      redirect_to technologies_path, alert: '删除失败'
    end
  end

  def upload_file
    render layout: false
  end

  def do_upload_file
    @log = TechnologyLog.new technology: @technology, file_path: params[:path], file_name: params[:file_name], user: current_user
    @log.save validate: false
    render js: 'location.reload()'
  end

  def show_version
    @version = @technology.versions.find_by id: params[:version_id]
    render layout: false
  end

  def apply
    render layout: false
  end

  def do_apply
    @technology = @log.technology
    begin
      if @log.update log_permit
        p @log.errors, 222222
        @log.do_apply!
        @flag = true
      else
        @flag = false
      end
      p @log.errors, 11111111
    rescue => e
      @flag = false
    end
  end

  def edit_file
    render layout: false
  end

  def update_file
    @technology = @log.technology
    @flag = @log.update_columns file_path: params[:path], file_name: params[:file_name]
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

  def technology_permit
    params.require('technology').permit(:no, :name, :valid_at, :desc, :technology_id, instance_ids: [], product_ids: [])
  end

  def log_permit
    params.require('technology_log').permit(:develop_id, :flow_id, :active_id)
  end

  def set_technology
    @technology = Technology.find_by id: params[:id]
    redirect_to technologies_path, alert: '找不到数据' unless @technology.present?
  end

  def set_log
    @log = current_user.technology_logs.find_by id: params[:id]
    redirect_to technologies_path, alert: '找不到数据' unless @log.present?
  end

  def set_audit_log
    @log = TechnologyLog.find_by id: params[:id]
    redirect_to technologies_path, alert: '找不到数据' unless @log.present?
  end

  def set_uptoken
    @uptoken = uptoken
  end

end
