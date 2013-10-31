require 'spec_helper'

describe Opg::API do
  include Rack::Test::Methods

  def app
    Opg::API
  end

  let(:person_json) do
    { 'title'=> 'Mr', 'first_name'=> 'James', 'last_name'=> 'Bond', 'address' => { 'post_code' => 'N1' } }
  end

  let(:applicant_id) do
    post '/api/applicants', person_json
    response = JSON.parse last_response.body
    response['id']
  end

  describe 'POST lpa including donor with missing field' do
    it "should return 422 error" do
      json = { 'applicant_id' => applicant_id, 'type' => 'health', 'donor' => { 'title' => 'Mr', 'first_name' => 'James' } }
      post '/api/lpas', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {'errors' =>
        { 'donor' =>
          { 'last_name'=>["can't be blank", 'is too short (minimum is 2 characters)'] }
        }
      }
    end
  end

  describe 'POST lpa including donor with blank field' do
    it "should return 422 error" do
      json = { 'applicant_id' => applicant_id, 'type' => 'health', 'donor' => { 'title' => 'Mr', 'first_name' => 'James', 'last_name' => '' } }
      post '/api/lpas', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"donor"=> {"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}} }
    end
  end

  describe 'POST lpa including an attorney with blank field' do
    it "should return 422 error" do
      json = { 'applicant_id' => applicant_id, 'type' => 'health', 'attorneys' => [{ 'title' => 'Mr', 'first_name' => 'James', 'last_name' => '' }] }
      post '/api/lpas', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors"=>{"attorneys"=> [{"last_name"=>["can't be blank", "is too short (minimum is 2 characters)"]}]} }
    end
  end

  describe "POST lpa including an attorney with title, name, and address postcode" do
    it 'should return 200 with JSON' do
      json = {
        'applicant_id' => applicant_id, 'type' => 'health',
        'attorneys' => [ person_json ]
      }
      post '/api/lpas', json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      response['attorneys'].first.delete('id')
      response['applicant'].delete('id')

      (id = response.delete('id')).should_not be_nil

      expected_json = json.
        except('applicant_id').
        merge('replacement_attorneys'=>[]).
        merge('applicant' => person_json.merge("uri" => "http://example.org/api/applicants/#{applicant_id}.json") ).
        merge('uri' => "http://example.org/api/lpas/#{id}.json")

      response.except('id').should == expected_json
    end
  end

  describe "POST lpa including donor and certificate provider with title, name, and address postcode" do
    it 'should return 200 with JSON' do
      json = {
        'applicant_id' => applicant_id, 'type' => 'health',
        'donor' => person_json,
        'certificate_provider' => person_json
      }
      post '/api/lpas', json
      last_response.status.should == 201
      response = JSON.parse last_response.body
      (applicant_id = response['applicant'].delete('id') ).should_not be_nil

      expected_json = json.
        except('applicant_id').
        merge("attorneys"=>[]).
        merge('replacement_attorneys'=>[]).
        merge('applicant'=>person_json.merge("uri" => "http://example.org/api/applicants/#{applicant_id}.json")  ).
        merge("uri" => "http://example.org/api/lpas/#{response['id']}.json")

      response.except('id').should == expected_json
      response['id'].should_not be_nil
    end
  end

  describe 'POST lpa including donor with unknown field' do
    it 'should return 422 error' do
      json = { 'applicant_id' => applicant_id, 'type' => 'health', 'donor' => { first: 'x' } }
      post '/api/lpas', json
      last_response.status.should == 422
      response = JSON.parse last_response.body
      response.should == {"errors" => {"unknown_attribute"=>["Attempted to set a value for 'first' which is not allowed on the model Donor."]}}
    end
  end

end
