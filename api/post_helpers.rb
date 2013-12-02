module Opg
  module PostHelpers

    def handle_post
      attributes = params.except('route_info','format').to_hash

      begin
        resource = yield attributes, request.env['X-USER-ID']

        if resource.persisted?
          resource.update_attribute(:uri, resource_uri(resource))

          present resource, with: resource.class.const_get(:Entity)
        else
          unprocessable_entity_error! error_messages(resource)
        end
      rescue Mongoid::Errors::UnknownAttribute => e
        unprocessable_entity_error! unknown_attribute_message(e)
      end
    end

    private

    def resource_uri resource
      host = [ request.env['rack.url_scheme'], '://', request.host ].join('')
      uri = [ host, request.path, '/', resource.id, '.json' ].join('')
    end
  end
end
