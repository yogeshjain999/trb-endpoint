require "representable/json/collection"

module Timeline::Representer
  class Index < Representable::Decorator
    include Representable::JSON::Collection

    items class: Status do
      property :id
      property :text
    end
  end
end
