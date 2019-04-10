class InstancesController < ApplicationController
  before_action :set_instance, only: [:show, :edit, :update, :destroy, :show_version, :upload_file, :do_upload_file]
  before_action :set_uptoken, only: :upload_file
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

  private

  def instance_permit
    params.require('instance').permit(:instance_no, :name, :norms, :desc, user_ids: [])
  end

  def set_instance
    @instance = Instance.find_by id: params[:id]
    redirect_to instances_path, alert: '找不到数据' unless @instance.present?
  end

  def set_uptoken
    @uptoken = uptoken
  end
end
