require_relative 'identifier'

module UriIdentifier
  extend ActiveSupport::Concern

  include Identifier

  included do
    field :uri, type: String

    entity do
      expose :uri
    end
  end
end
