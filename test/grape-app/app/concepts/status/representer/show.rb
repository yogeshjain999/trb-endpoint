module Status::Representer
  class Show < Representable::Decorator
    include Representable::JSON

    property :id
    property :text
  end
end
