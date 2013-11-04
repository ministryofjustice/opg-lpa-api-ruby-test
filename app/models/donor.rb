require_relative 'date_of_birth'
require_relative 'personal_details'

class Donor
  include Mongoid::Document
  include Grape::Entity::DSL

  include DateOfBirth
  include PersonalDetails

  embedded_in :lpa

  before_validation do
    if attributes_before_type_cast['date_of_birth']
      begin
        Date.parse attributes_before_type_cast['date_of_birth']
      rescue Exception => e
        self.date_of_birth = nil
        errors['date_of_birth'] = 'is an invalid date'
      end
    end
  end

  after_validation do
    if !errors.blank?
      if errors.keys.include?(:date_of_birth) && (
          errors['date_of_birth'].delete('translation missing: en.mongoid.errors.models.donor.attributes.date_of_birth.invalid_date') ||
          errors['date_of_birth'].delete('translation missing: en.mongoid.errors.models.donor.attributes.date_of_birth.on_or_before')
        )
        errors['date_of_birth'].delete('is an invalid date')
        errors['date_of_birth'] = 'is an invalid date'
      end
    end
  end

end
