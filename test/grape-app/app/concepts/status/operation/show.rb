module Status::Operation
  class Show < Trailblazer::Operation
    step Model(Status, :find_by, not_found_terminus: true)
  end
end
