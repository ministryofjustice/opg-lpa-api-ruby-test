require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API, :type => :api do

  include_context "shared LPA setup"

  describe "GET lpa with existing id" do
    it 'should return JSON' do
      get "/api/lpas/#{lpa_id}"
      response = JSON.parse last_response.body
      response['id'].should == lpa_id
    end
  end

  describe "GET lpa with invalid id" do
    it 'should return 404' do
      get "/api/lpas/xxyyzz"
      last_response.status.should == 404
      last_response.body.should == '{"error":"Document(s) not found for class Lpa with id(s) xxyyzz."}'
    end
  end
end
