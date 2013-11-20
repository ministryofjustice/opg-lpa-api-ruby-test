module Opg
  module PostHelpers

    def handle_post
      attributes = params.except('route_info','format').to_hash

      begin
        host = [ request.env['rack.url_scheme'], '://', request.host ].join('')

        resource = yield attributes

        if resource.persisted?
          uri = [ host, request.path, '/', resource.id, '.json' ].join('')
          resource.update_attribute(:uri, uri)

          present resource, with: resource.class.const_get(:Entity)
        else
          unprocessable_entity_error! error_messages(resource)
        end
      rescue Mongoid::Errors::UnknownAttribute => e
        unprocessable_entity_error! unknown_attribute_message(e)
      end
    end

  end
end
