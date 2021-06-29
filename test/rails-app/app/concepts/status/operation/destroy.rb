module Status::Operation
  class Destroy < Trailblazer::Operation
    step Subprocess(Show), Output(:not_found) => End(:not_found)
    # step :destroy
  end
end
