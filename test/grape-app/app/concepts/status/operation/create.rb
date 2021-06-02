module Status::Operation
  class Create < Trailblazer::Operation
    step Model(Status)
    step Contract::Build(constant: Status::Contract::Create)
    step Contract::Validate(invalid_data_terminus: true)
    step Contract::Persist(method: :sync)
  end
end
