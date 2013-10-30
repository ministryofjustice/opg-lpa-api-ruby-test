shared_context "shared LPA setup" do

  let(:person_json) do
    { 'title'=> 'Mr', 'first_name'=> 'James', 'last_name'=> 'Bond', 'address' => { 'post_code' => 'N1' } }
  end

  let(:applicant_id) do
    post '/api/applicants', person_json
    response = JSON.parse last_response.body
    response['id']
  end

  let(:lpa_id) do
    json = {
      'applicant_id' => applicant_id, 'type' => 'health',
      'donor' => person_json
    }
    post '/api/lpas', json
    response = JSON.parse last_response.body
    response['id']
  end
end
