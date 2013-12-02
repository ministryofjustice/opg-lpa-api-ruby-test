require_relative 'personal_details_with_phone'

class PersonToBeTold
  include Mongoid::Document
  include Grape::Entity::DSL

  include PersonalDetailsWithPhone

  embedded_in :lpa

  entity do
    expose :email, if: ->(object, options) { object.email }
  end
end
