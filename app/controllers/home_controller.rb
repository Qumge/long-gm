class HomeController < ApplicationController
  def index
    data = []
    if params[:table_search].present?
      instances = Instance.search_conn(params)
      products = Product.search_conn(params)
      technologies = Technology.search_conn(params)
      data = (instances + products + technologies).sort{ |a, b| b.updated_at <=> a.updated_at }
    end
    @datas = Kaminari.paginate_array(data).page(params[:page]).per(Settings.per_page)
  end
end
