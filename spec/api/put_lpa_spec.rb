require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API do
  include Rack::Test::Methods

  def app
    Opg::API
  end

  include_context "shared LPA setup"

  describe "PUT lpa with existing id" do
    it 'should return JSON' do
      json = { 'type' => 'financial' }
      put "/api/lpas/#{lpa_id}", json
      puts last_response.body
      response = JSON.parse last_response.body
      response['type'].should == 'financial'
    end
  end

  describe "PUT lpa with donor field blank" do
    it 'should return JSON' do
      json = { 'donor' => donor_json.merge('last_name' => '') }
      put "/api/lpas/#{lpa_id}", json
      puts last_response.body
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"donor"=> {"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}} }
    end
  end

end
