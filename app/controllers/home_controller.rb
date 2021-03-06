class HomeController < ApplicationController
  layout "cytoscape", :only => [ :cytoscape ]
  def files_search
    data = []
    if params[:table_search].present?
      instances = Instance.search_conn(params)
      products = Product.search_conn(params)
      technologies = Technology.search_conn(params)
      data = (instances + products + technologies).sort{ |a, b| b.updated_at <=> a.updated_at }
    end
    @datas = Kaminari.paginate_array(data).page(params[:page]).per(Settings.per_page)
  end

  def index
    instances = current_user.instances.search_conn(params).where('instances.file_path is not null')
    products = current_user.products.search_conn(params).where('products.file_path is not null')
    technologies = Technology.search_conn(params).where('technologies.file_path is not null')
    data = (instances + products + technologies).sort{ |a, b| b.updated_at <=> a.updated_at }
    @datas = Kaminari.paginate_array(data).page(params[:page]).per(Settings.per_page)
  end

  def cytoscape
    @products = Product.includes(:instances, :technology).references(:all)
    @instances = Instance.includes(:products, :technology).references(:all)
    @technologies = Technology.all
    @technologies1 = Technology.includes({products: :instances}).references(:all)
    @technologies2 = Technology.includes({instances: :products}).references(:all)
    @product_instances = ProductsInstance.includes(product: :technology, instance: :technology).references(:all)
    #@technology_instances = TechnologyInstance.includes(:technology, instance: :products).references(:all)

    if params[:product_id].present?
      @products = @products.where('products.id = ?', params[:product_id])
      @instances = @instances.where('products.id = ?', params[:product_id])
      @technologies1 = @technologies1.where('products.id = ?', params[:product_id])
      @technologies2 = @technologies2.where('products.id = ?', params[:product_id])
      @product_instances = @product_instances.where('products.id = ?', params[:product_id])
      #@technology_instances = @technology_instances.where('products.id = ?', params[:product_id])
      @technologies = (@technologies1 + @technologies2).uniq

    elsif params[:instance_id].present?
      @products = @products.where('instances.id = ?', params[:instance_id])
      @instances = @instances.where('instances.id = ?', params[:instance_id])
      @technologies1 = @technologies1.where('instances.id = ?', params[:instance_id])
      @technologies2 = @technologies2.where('instances.id = ?', params[:instance_id])
      @product_instances = @product_instances.where('instances.id = ?', params[:instance_id])
      @technologies = (@technologies1 + @technologies2).uniq
      #@technology_instances = @technology_instances.where('instances.id = ?', params[:instance_id])
    elsif params[:technology_id].present?
      @products = @products.where('technologies.id = ?', params[:technology_id])
      @instances = @instances.where('technologies.id = ?', params[:technology_id])
      @technologies = Technology.where('technologies.id = ?', params[:technology_id])
      @product_instances = @product_instances.where('technologies.id = ?', params[:technology_id])
      #@technology_instances = @technology_instances.where('technologies.id = ?', params[:technology_id])
    end
  end

  def stl
    render layout: false
  end
end
