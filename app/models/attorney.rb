require_relative 'person_name'

class Attorney
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonName

  embeds_one :address, as: :addressable

  entity do
    expose :_id

    expose :address, :using => Address::Entity, :if => lambda { |object, options| object.address }
  end
end
