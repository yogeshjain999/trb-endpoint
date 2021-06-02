require_relative "test_helper"

class StatusApiTest < Minitest::Spec
  it 'returns status' do
    header 'api-key', 'secret'
    get "/v1/status", id: 1

    assert_equal last_response.status, 200
    assert_equal JSON.parse(last_response.body), {"text"=>"1 :metal:"}
  end

  it 'returns 404 when status is not found' do
    header 'api-key', 'secret'
    get "/v1/status", id: 2

    assert_equal last_response.status, 404
    assert_equal JSON.parse(last_response.body), {"error"=>"2 is invalid!"}
  end

  it 'creates new status' do
    header 'api-key', 'secret'
    post "/v1/status", { text: "Yo!" }

    assert_equal last_response.status, 201
    assert_equal JSON.parse(last_response.body), {"text"=>"Yo!"}
  end

  it 'returns validation error for invalid input' do
    header 'api-key', 'secret'
    post "/v1/status"

    assert_equal last_response.status, 422
    assert_equal JSON.parse(last_response.body), {"error"=>["Text must be filled"]}
  end
end
