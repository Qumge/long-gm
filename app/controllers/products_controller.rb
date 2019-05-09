class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :show_version, :upload_file, :do_upload_file]
  before_action :set_uptoken, only: [:upload_file, :edit_file]
  before_action :set_log, only: [:edit_file, :update_file, :apply]
  before_action :set_audit_log, only: [:do_develop_audit, :do_flow_audit, :do_active_audit, :do_failed_audit]
  include ApplicationHelper
  def index
    @products = Product.search_conn(params).page(params[:page]).per(Settings.per_page)
  end

  def new
    @product = Product.new
    render layout: false
  end

  def create
    @product = Product.new
    @product.user = current_user
    @flag = @product.update product_permit
  end

  def show

  end

  def edit
    render layout: false
  end

  def update
    @flag = @product.update product_permit
  end

  def destroy
    if @product.destroy
      redirect_to products_path, notice: '删除成功'
    else
      redirect_to products_path, alert: '删除失败'
    end
  end

  def upload_file
    render layout: false
  end

  def do_upload_file
    ProductLog.create product: @product, file_path: params[:path], file_name: params[:file_name], user: current_user
    render js: 'location.reload()'
  end

  def show_version
    @version = @product.versions.find_by id: params[:version_id]
    render layout: false
  end

  def apply
    @product = @log.product
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
    @product = @log.product
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

  def product_permit
    params.require('product').permit(:category_id,:product_no, :name, :norms, :desc, instance_ids: [], user_ids: [])
  end

  def set_product
    @product = Product.find_by id: params[:id]
    redirect_to products_path, alert: '找不到数据' unless @product.present?
  end

  def set_log
    @log = current_user.product_logs.find_by id: params[:id]
    redirect_to products_path, alert: '找不到数据' unless @log.present?
  end

  def set_audit_log
    @log = ProductLog.find_by id: params[:id]
    redirect_to products_path, alert: '找不到数据' unless @log.present?
  end

  def set_uptoken
    @uptoken = uptoken
  end

end
