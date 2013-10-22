module Lpa
  class PostDonor < Grape::API
    format :json
    desc "Creates a donor."
    resource :donor do
      post do
        donor = Donor.create(params['donor']) #
        present donor, with: Donor::Entity
      end
    end
  end
end

