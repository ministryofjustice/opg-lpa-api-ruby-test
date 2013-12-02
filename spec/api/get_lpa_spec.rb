require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API, :type => :api do

  include_context "shared LPA setup"

  describe "GET lpa with existing id" do
    it 'should return JSON' do
      id = lpa_id # creates applicant and lpa
      get "/api/lpas/#{id}", {}, { 'X-USER-ID' => email }
      response = JSON.parse last_response.body
      response['id'].should == id
    end
  end

  describe "GET lpa with invalid id" do
    it 'should return 403 Forbidden' do
      get "/api/lpas/xxyyzz", {}, { 'X-USER-ID' => email }
      last_response.status.should == 403
      last_response.body.should == '{"error":"Forbidden"}'
    end
  end

  describe "GET lpa when authenticated user is not the applicant" do
    before do
      id = lpa_id # creates applicant and lpa
      get "/api/lpas/#{id}", {}, { 'X-USER-ID' => 'bad_user@example.com' }
    end

    it 'returns 403 Forbidden' do
      last_response.status.should == 403
      last_response.body.should == '{"error":"Forbidden"}'
    end
  end

end
