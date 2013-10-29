module Opg
  module PostHelpers

    def handle_post
      attributes = params.except('route_info','format')
      def attributes.permitted?; true; end

      begin
        object = yield attributes

        if object.persisted?
          present object, with: object.class.const_get(:Entity)
        else
          unprocessable_entity_error! error_messages(object)
        end
      rescue Mongoid::Errors::UnknownAttribute => e
        unprocessable_entity_error! unknown_attribute_message(e)
      end
    end

  end
end
