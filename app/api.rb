module Lpa
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::Lpa::PostDonor
    add_swagger_documentation api_version: 'v1'
  end
end

