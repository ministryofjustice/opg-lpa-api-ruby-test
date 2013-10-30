require 'spec_helper'

describe Opg::API do
  include Rack::Test::Methods

  def app
    Opg::API
  end

  describe 'POST applicant with missing field' do
    it "should return 422 error" do
      json = { 'title' => 'Mr', 'first_name' => 'James' }
      post '/api/applicants', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {'errors' => { 'last_name'=>["can't be blank", 'is too short (minimum is 2 characters)'] } }
    end
  end

  describe 'POST applicant with blank field' do
    it "should return 422 error" do
      json = { 'title' => 'Mr', 'first_name' => 'James', 'last_name' => '' }
      post '/api/applicants', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" =>{ "last_name"=>["can't be blank", "is too short (minimum is 2 characters)"] } }
    end
  end

  describe "POST applicant including title, name, and address postcode" do
    it 'should return 200 with JSON' do
      json = {
        'title' => 'Mr',
        'first_name' => 'James',
        'last_name' => 'Bond',
        'address' => { 'post_code' => 'N1' }
      }

      post '/api/applicants', json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      response.except('id').should == json.merge("uri" => "http://example.org/api/applicants/#{response['id']}.json")
      response['id'].should_not be_nil
    end
  end

  describe 'POST applicant with unknown field' do
    it 'should return 422 error' do
      json = { 'first' => 'x' }
      post '/api/applicants', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" => {"unknown_attribute"=>["Attempted to set a value for 'first' which is not allowed on the model Applicant."]}}
    end
  end

end
