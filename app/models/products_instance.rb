class ProductsInstance < ActiveRecord::Base
  belongs_to :product
  belongs_to :instance
end
