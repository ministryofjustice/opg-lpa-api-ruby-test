require 'spec_helper'
require_relative 'shared_lpa_setup'

describe Opg::API, :type => :api do

  include_context "shared LPA setup"

  before do
    applicant_id # create applicant first
  end

  def post_lpa params
    post '/api/lpas', params, { 'X-USER-ID' => email }
  end

  describe 'POST lpa including donor with missing field' do
    it "should return 422 error" do
      json = { 'type' => 'health', 'donor' => { 'title' => 'Mr', 'first_name' => 'James' } }
      post_lpa json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {'errors' =>
        { 'donor' =>
          { 'date_of_birth'=>["can't be blank", "is an invalid date"],
            'last_name'=>["can't be blank", 'is too short (minimum is 2 characters)'] }
        }
      }
    end
  end

  describe 'POST lpa including donor with blank field' do
    it "should return 422 error" do
      json = { 'type' => 'health', 'donor' => donor_json.merge('last_name' => '') }
      post_lpa json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"donor"=> {"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}} }
    end
  end

  describe 'POST lpa including an attorney with blank field' do
    it "should return 422 error" do
      json = { 'type' => 'health', 'attorneys' => [attorney_json.merge('last_name' => '' )] }
      post_lpa json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"attorneys"=> [{"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}]} }
    end
  end

  describe "POST lpa including an attorney with title, name, dob, and address postcode" do
    it 'should return 200 with JSON' do
      json = {
        'type' => 'health',
        'attorneys' => [ attorney_json ]
      }
      post_lpa json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      response['attorneys'].first.delete('id')
      response['applicant'].delete('id')

      (id = response.delete('id')).should_not be_nil

      expected_json = json.
        except('applicant_id').
        merge('replacement_attorneys'=>[]).
        merge('people_to_be_told'=>[]).
        merge('applicant' => applicant_json.merge("uri" => "http://example.org/api/applicants/#{applicant_id}.json") ).
        merge('uri' => "http://example.org/api/lpas/#{id}.json")

      response.except('id').should == expected_json
    end
  end

  describe "POST lpa including donor and certificate provider with title, name, and address postcode" do
    it 'should return 200 with JSON' do
      json = {
        'type' => 'health',
        'donor' => donor_json,
        'certificate_provider' => person_json.except('phone')
      }
      post_lpa json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      (applicant_id = response['applicant'].delete('id') ).should_not be_nil

      expected_json = json.
        except('applicant_id').
        merge("attorneys"=>[]).
        merge('people_to_be_told'=>[]).
        merge('replacement_attorneys'=>[]).
        merge('applicant'=> applicant_json.merge("uri" => "http://example.org/api/applicants/#{applicant_id}.json") ).
        merge("uri" => "http://example.org/api/lpas/#{response['id']}.json")

      response.except('id').should == expected_json
      response['id'].should_not be_nil
    end
  end

  describe 'POST lpa including donor with unknown field' do
    it 'should return 422 error' do
      json = { 'type' => 'health', 'donor' => { first: 'x' } }
      post_lpa json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" => {"unknown_attribute"=>["Attempted to set a value for 'first' which is not allowed on the model Donor."]}}
    end
  end

end
