
module Identifier
  extend ActiveSupport::Concern

  included do
    def id
      _id.to_s
    end

    entity do
      expose :id
    end
  end
end
