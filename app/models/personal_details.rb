require_relative 'person_name'

module PersonalDetails
  extend ActiveSupport::Concern

  include PersonName

  included do
    field :email, type: String

    embeds_one :address, as: :addressable
    accepts_nested_attributes_for :address, allow_destroy: true

    entity do
      expose :address, using: Address::Entity, if: ->(object, options) { object.address }
      expose :email, if: ->(object, options) { object.email }
    end
  end
end
