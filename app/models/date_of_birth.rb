module DateOfBirth
  extend ActiveSupport::Concern

  included do
    field :date_of_birth, type: Date

    validates :date_of_birth, presence: true
    validates_date :date_of_birth, :on_or_before => lambda { Date.current }, :message => 'is invalid date'

    entity do
      expose :date_of_birth, :if => lambda { |object, options| object.date_of_birth }
    end

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
        model = self.class.name.to_s.downcase
        if errors.keys.include?(:date_of_birth) && (
            errors['date_of_birth'].delete("translation missing: en.mongoid.errors.models.#{model}.attributes.date_of_birth.invalid_date") ||
            errors['date_of_birth'].delete("translation missing: en.mongoid.errors.models.#{model}.attributes.date_of_birth.on_or_before")
          )
          errors['date_of_birth'].delete('is an invalid date')
          errors['date_of_birth'] = 'is an invalid date'
        end
      end
    end
  end

end
