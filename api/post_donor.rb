module Opg
  class PostDonor < Grape::API
    format :json
    desc "Creates a donor."
    resource :donors do
      post do
        attributes = params.except('route_info','format')
        def attributes.permitted?
          true
        end
        puts attributes.inspect
        begin
          donor = Donor.create(attributes) #

          if donor.persisted?
            present donor, with: Donor::Entity
          else
            # ActiveResource expects 422 status code for validation errors
            unprocessable_entity_code = 422
            puts donor.errors.messages.inspect
            error!({ errors: donor.errors.messages }, unprocessable_entity_code)
          end
        rescue Mongoid::Errors::UnknownAttribute => e
          unprocessable_entity_code = 422
          message = e.to_s.split('Summary:').first.sub('Problem:','').strip
          error!({ errors: {unknown_attribute: [message]} }, unprocessable_entity_code)
        end
      end
    end
  end
end

