shared_context "shared LPA setup" do

  let(:dob) do
    { 'date_of_birth'=>'1988-10-10' }
  end

  let(:person_json) do
    { 'title'=> 'Mr', 'first_name'=> 'James', 'last_name'=> 'Bond', 'address' => { 'post_code' => 'N1' }, 'email' => '007@example.com', 'phone' => '123 334' }
  end

  let(:applicant_json) do
    person_json.merge(dob)
  end

  let(:donor_json) do
    person_json.merge(dob)
  end

  let(:attorney_json) do
    person_json.merge(dob)
  end

  let(:applicant_id) do
    post '/api/applicants', applicant_json
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
