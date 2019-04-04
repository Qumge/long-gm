class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :show_version, :upload_file, :do_upload_file]
  before_action :set_uptoken, only: :upload_file
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

  private

  def product_permit
    params.require('product').permit(:product_no, :name, :norms, :desc)
  end

  def set_product
    @product = Product.find_by id: params[:id]
    redirect_to products_path, alert: '找不到数据' unless @product.present?
  end

  def set_uptoken
    @uptoken = uptoken
  end

end
