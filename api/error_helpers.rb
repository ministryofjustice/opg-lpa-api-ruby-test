module Opg
  module ErrorHelpers
    def error_messages resource
      messages = {}

      resource.errors.messages.each do |name, message_list|
        if message_list.include?('is invalid') && (child = resource.send(name.to_sym))
          if child.is_a? Array
            messages[name] = child.collect {|e| e.errors.messages}
          else
            messages[name] = child.errors.messages
          end
        else
          messages[name] = message_list
        end
      end
      messages
    end

    def mongoid_exception_message e
      e.to_s.split('Summary:').first.sub('Problem:','').strip
    end

    def unknown_attribute_message e
      {unknown_attribute: [mongoid_exception_message(e)]}
    end

    def unprocessable_entity_error! messages
      # ActiveResource expects 422 status code for validation errors
      unprocessable_entity_code = 422
      error!({ errors: messages }, unprocessable_entity_code)
    end
  end
end
