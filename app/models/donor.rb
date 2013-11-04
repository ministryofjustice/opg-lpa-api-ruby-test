require_relative 'date_of_birth'
require_relative 'personal_details'

class Donor
  include Mongoid::Document
  include Grape::Entity::DSL

  include DateOfBirth
  include PersonalDetails

  embedded_in :lpa

  after_validation do
    if !errors.blank?
      if errors.keys.include?(:date_of_birth) && errors['date_of_birth'].delete('translation missing: en.mongoid.errors.models.donor.attributes.date_of_birth.invalid_date')
        errors['date_of_birth'] = 'is an invalid date'
      end
    end
  end

end
