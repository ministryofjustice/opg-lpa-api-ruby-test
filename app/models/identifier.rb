
module Identifier
  extend ActiveSupport::Concern

  included do
    field :uri, type: String

    def id
      _id.to_s
    end

    entity do
      expose :id
      expose :uri
    end
  end
end
