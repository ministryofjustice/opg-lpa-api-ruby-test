require_relative 'personal_details'

module PersonalDetailsWithPhone
  extend ActiveSupport::Concern

  include PersonalDetails

  included do
    field :phone, type: String

    entity do
      expose :phone, if: ->(object, options) { object.phone }
    end
  end
end
