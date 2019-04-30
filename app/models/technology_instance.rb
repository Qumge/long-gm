class TechnologyInstance < ActiveRecord::Base
  belongs_to :technology
  belongs_to :instance
end

