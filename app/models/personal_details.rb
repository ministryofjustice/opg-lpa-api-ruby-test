require_relative 'person_name'

module PersonalDetails
  extend ActiveSupport::Concern

  include PersonName

  included do
    embeds_one :address, as: :addressable

    entity do
      expose :address, :using => Address::Entity, :if => lambda { |object, options| object.address }
    end
  end
end
