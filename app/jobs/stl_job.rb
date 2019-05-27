class StlJob < ActiveJob::Base
  queue_as :default

  def perform(model)
    # Do somethin
    model.stp2_stl
  end
end
