
module Identifier
  extend ActiveSupport::Concern

  included do

    entity do
      expose :id do |instance, options|
        instance.id.to_s
      end
    end
  end
end
