require "reform/form/dry"

module Status::Contract
  class Create < Reform::Form
    feature Reform::Form::Dry

    property :id
    property :text

    validation do
      params do
        required(:text).filled
      end
    end
  end
end
