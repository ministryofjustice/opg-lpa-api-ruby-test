module Opg
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::Opg::PostApplicant
    mount ::Opg::PostLpa
    add_swagger_documentation api_version: 'v1'
  end
end

