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

      response = JSON.parse last_response.body
      response['type'].should == 'financial'
    end
  end

  describe "PUT lpa with donor field blank" do
    it 'should return JSON' do
      json = { 'donor' => donor_json.merge('last_name' => '') }
      put "/api/lpas/#{lpa_id}", json

      response = JSON.parse last_response.body
      response.should == {"errors"=>{"donor"=> {"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}} }
    end
  end

  describe "PUT lpa with attorneys" do
    before do
      json = { 'attorneys' => [ attorney_json, attorney_json.merge('last_name' => 'Kirk') ] }
      put "/api/lpas/#{lpa_id}", json
      @response = JSON.parse last_response.body
      @bond_attorney_id = @response['attorneys'].detect{|x| x['last_name'][/Bond/]}['id']
      @kirk_attorney_id = @response['attorneys'].detect{|x| x['last_name'][/Kirk/]}['id']

      @bond_attorney_json = attorney_json.merge('id' => @bond_attorney_id)
      @kirk_attorney_json = attorney_json.merge('last_name' => 'Kirk').merge('id' => @kirk_attorney_id)
    end

    it 'should return JSON with attorneys' do
      @response['attorneys'].should == [ @bond_attorney_json, @kirk_attorney_json ]
    end

    describe 'PUT lpa attorneys array with id and _destroy' do
      it 'should return JSON with attorney removed' do
        json = { 'attorneys' => [ @kirk_attorney_json.merge( '_destroy' => true ) ] }
        put "/api/lpas/#{lpa_id}", json
        response = JSON.parse last_response.body
        response['attorneys'].should == [ @bond_attorney_json ]

        Lpa.find(lpa_id).attorneys.size.should == 1
      end
    end
  end
end
