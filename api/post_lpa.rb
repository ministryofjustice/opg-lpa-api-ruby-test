module Opg
  class PostDonor < Grape::API
    format :json

    helpers do
      def error_messages lpa
        messages = {}

        lpa.errors.messages.each do |name, message_list|
          if message_list.include?('is invalid') && (child = lpa.send(name.to_sym))
            messages[name] = child.errors.messages
          else
            messages[name] = message_list
          end
        end
        messages
      end

      def unknown_attribute_message e
        message = e.to_s.split('Summary:').first.sub('Problem:','').strip
        {unknown_attribute: [message]}
      end

      def unprocessable_entity_error! messages
        # ActiveResource expects 422 status code for validation errors
        unprocessable_entity_code = 422
        error!({ errors: messages }, unprocessable_entity_code)
      end
    end

    desc "Creates an LPA application."
    resource :lpas do
      post do
        attributes = params.except('route_info','format')
        def attributes.permitted?; true; end

        begin
          lpa = Lpa.create(attributes)

          if lpa.persisted?
            present lpa, with: Lpa::Entity
          else
            unprocessable_entity_error! error_messages(lpa)
          end
        rescue Mongoid::Errors::UnknownAttribute => e
          unprocessable_entity_error! unknown_attribute_message(e)
        end
      end
    end
  end

end

