class TechnologiesController < ApplicationController
  include ApplicationHelper
  before_action :set_uptoken, only: [:edit, :update, :new, :create]
  before_action :set_technology, only: [:edit, :update, :destroy, :show]
  def index
    @technologies = Technology.search_conn(params).page(params[:page]).per(Settings.per_page)
  end

  def new
    @technology = Technology.new
    render layout: false
  end

  def create
    @technology = Technology.new
    @technology.user = current_user
    @technology.file_path = params[:file_path]
    @technology.file_name = params[:file_path]
    @flag = @technology.update technology_permit
  end

  def show

  end

  def edit
    render layout: false
  end

  def update
    @technology.file_path = params[:file_path]
    @technology.file_name = params[:file_path]
    @flag = @technology.update technology_permit
  end

  def destroy
    if @technology.destroy
      redirect_to technologies_path, notice: '删除成功'
    else
      redirect_to technologies_path, alert: '删除失败'
    end
  end

  private
  def set_technology
    @technology = Technology.find_by id: params[:id]
    redirect_to technologies_path, alert: '找不到数据' unless @technology.present?
  end
  def technology_permit
    params.require('technology').permit(:no, :name, :norms, :desc, :valid_at, instance_ids: [])
  end
  def set_uptoken
    @uptoken = uptoken
  end
end
