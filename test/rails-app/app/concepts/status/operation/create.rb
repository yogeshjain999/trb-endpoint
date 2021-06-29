module Status::Operation
  class Create < Trailblazer::Operation
    step Subprocess(New)
    step Contract::Validate(invalid_data_terminus: true)
    step Contract::Persist(method: :sync)
  end
end
