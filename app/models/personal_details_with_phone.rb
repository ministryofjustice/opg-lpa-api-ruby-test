require_relative 'personal_details'

module PersonalDetailsWithPhone
  extend ActiveSupport::Concern

  include PersonalDetails

  included do
    field :telephone, type: String

    entity do
      expose :telephone, if: ->(object, options) { object.telephone }
    end
  end
end
