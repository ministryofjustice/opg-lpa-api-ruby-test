module Opg
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::Opg::PostApplicant
    mount ::Opg::PostLpa
    mount ::Opg::GetLpa
    mount ::Opg::GetApplicant
    mount ::Opg::PutLpa
    add_swagger_documentation api_version: 'v1', markdown: true
  end
end

