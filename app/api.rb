module Opg
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::Opg::PostDonor
    add_swagger_documentation api_version: 'v1'
  end
end

