class MattersController < ApplicationController
  include ApplicationHelper
  before_action :set_matter, only: [:show, :edit, :update, :destroy, :upload_file, :do_upload_file, :notices, :send_notice, :countersign, :agree]
  before_action :set_uptoken, only: [:upload_file]
  def index
    @matters = Matter.search_conn(params).order('updated_at desc').page(params[:page]).per(Settings.per_page)
  end

  def new
    @matter = current_user.matters.new
    render layout: false
  end

  def create
    @matter = current_user.matters.new
    @flag = @matter.update matter_permit
  end

  def show

  end

  def edit
    render layout: false
  end

  def update
    @flag = @matter.update matter_permit
  end

  def destroy
    if @matter.destroy
      redirect_to matters_path, notice: '删除成功'
    else
      redirect_to matters_path, alert: '删除失败'
    end
  end

  def upload_file
    render layout: false
  end

  def do_upload_file
    user_matter = UserMatter.find_by user: current_user, matter: @matter
    UserMatter.create user: current_user, matter: @matter unless user_matter.present?
    @matter.update file_path: params[:path], file_name: params[:file_name], file_user: current_user, last_update_at: DateTime.now
    render js: 'location.reload()'
  end

  def show_version
    @version = @matter.versions.find_by id: params[:version_id]
    render layout: false
  end

  def notices
    #render layout: false
    render layout: false
  end

  def send_notice
    if params[:user_ids].present?
      params[:user_ids].each do|user_id|
        user = User.find_by id: user_id
        current_user.send_bom_notice user, @matter if user.present?
      end
    end
  end

  def agree
    user_matter = @matter.user_matter current_user

    user_matter.update agree: true
  end

  def countersign
    @matter.update countersign_user: current_user, countersign_at: DateTime.now, status: 'countersign'
    current_user.send_countersign_notice @matter.users, @matter
  end

  private
  def matter_permit
    params.require('matter').permit(:name, :desc)
  end

  def set_matter
    @matter = Matter.find_by id: params[:id]
    redirect_to matters_path, alert: '找不到数据' unless @matter.present?
  end

  def set_uptoken
    @uptoken = uptoken
  end
end
