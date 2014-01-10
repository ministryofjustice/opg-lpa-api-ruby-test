require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API, :type => :api do

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

  describe "PUT lpa with attorney field blank and applicant nested hash" do
    before do
      json = lpa_json.except('applicant_id').merge( 'applicant' => applicant_json.merge('id' => applicant_id ) ).merge( 'attorneys' => [ attorney_json.merge('last_name' => '') ] )
      put "/api/lpas/#{lpa_id}", json
      @response = JSON.parse last_response.body
    end

    it 'should return JSON error' do
      @response.should == {"errors"=>{"attorneys"=> [{"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}] } }
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
      @response['attorneys'].should include(@bond_attorney_json)
      @response['attorneys'].should include(@kirk_attorney_json)
    end

    describe 'PUT lpa attorneys array with id and _destroy' do
      before do
        json = { 'attorneys' => [ @kirk_attorney_json.merge( '_destroy' => true ) ] }
        put "/api/lpas/#{lpa_id}", json
      end

      it 'should return JSON with attorney removed' do
        response = JSON.parse last_response.body
        Lpa.find(lpa_id).attorneys.size.should == 1
        response['attorneys'].should == [ @bond_attorney_json ]
      end

      describe 'PUT lpa attorneys array with second id and _destroy' do
        before do
          json = { 'attorneys' => [ @bond_attorney_json.merge( '_destroy' => true ) ] }
          put "/api/lpas/#{lpa_id}", json
        end

        it 'should return JSON with empty attorneys' do
          response = JSON.parse last_response.body
          response['attorneys'].should == [ ]
          response['attorneys'].should be_empty

          Lpa.find(lpa_id).attorneys.size.should == 0
        end
      end
    end
  end

  describe 'PUT lpa attorneys with one marked as registration applicant' do
    before do
      json = { 'attorneys' => [ attorney_json.merge( 'registration_applicant' => true ), attorney_json ] }
      put "/api/lpas/#{lpa_id}", json
    end

    it 'should return JSON with the correct attorney marked as registration applicant' do
      Lpa.find(lpa_id).attorneys[0].registration_applicant.should be_true
      Lpa.find(lpa_id).attorneys[1].registration_applicant.should_not be_true
    end
  end

  describe 'PUT lpa with donor marked as registration applicant' do
    before do
      json = { 'donor' => donor_json.merge('registration_applicant' => true) }
      put "/api/lpas/#{lpa_id}", json
    end

    it 'should return JSON with the donor marked as registration applicant' do
      Lpa.find(lpa_id).donor.registration_applicant.should be_true
    end
  end
end
