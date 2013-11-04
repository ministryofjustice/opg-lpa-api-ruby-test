shared_context 'shared spec data' do

  let(:dob) do
    { 'date_of_birth'=>'1988-10-10' }
  end

  let(:person_json) do
    { 'title'=> 'Mr', 'first_name'=> 'James', 'last_name'=> 'Bond', 'address' => { 'post_code' => 'N1' } }
  end

  let(:donor_json) do
    person_json.merge(dob)
  end

  let(:applicant_id) do
    post '/api/applicants', person_json
    response = JSON.parse last_response.body
    response['id']
  end

  let(:lpa_id) do
    json = {
      'applicant_id' => applicant_id, 'type' => 'health',
      'donor' => donor_json
    }
    post '/api/lpas', json
    response = JSON.parse last_response.body
    response['id']
  end

end

