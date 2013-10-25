module Lpa
  class PostDonor < Grape::API
    format :json
    desc "Creates a donor."
    resource :donor do
      post do
        {
          title: params[:title],
          first_name: params[:first_name]
        }
      end
    end
  end
end

