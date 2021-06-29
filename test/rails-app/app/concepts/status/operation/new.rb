module Status::Operation
  class New < Trailblazer::Operation
    step Model(Status)
    step Contract::Build(constant: Status::Contract::Form)
  end
end
