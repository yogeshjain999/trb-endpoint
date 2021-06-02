module Status::Operation
  class Update < Trailblazer::Operation
    step Model(User, :find_by, not_found_terminus: true)
    # DISCUSS: Accept terminus flag in Pundit ?
    step Policy::Pundit(Status::Policy, :update?), Output(:failure) => End(:unauthorized)
    step Contract::Build(constant: UserForm)
    step Contract::Validate(invalid_data_terminus: true)
  end
end
