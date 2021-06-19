require_relative "test_helper"

class StatusApiTest < Minitest::Spec
  def status(action, params = {})
    header 'api-key', 'secret'
    send action, "/v1/status", **params
  end

  it 'returns status' do
    status :get, id: 1

    assert_equal last_response.status, 200
    assert_equal JSON.parse(last_response.body), {"text"=>"1 :metal:"}
  end

  it 'returns 404 when status is not found' do
    status :get, id: 2

    assert_equal last_response.status, 404
    assert_equal JSON.parse(last_response.body), {"error"=>"2 is invalid!"}
  end

  it 'creates new status' do
    status :post, text: "Yo!"

    assert_equal last_response.status, 201
    assert_equal JSON.parse(last_response.body), {"text"=>"Yo!"}
  end

  it 'returns validation error for invalid input' do
    status :post

    assert_equal last_response.status, 422
    assert_equal JSON.parse(last_response.body), {"error"=>["Text must be filled"]}
  end

  it 'destroys status' do
    status :delete, id: 1

    assert_equal last_response.status, 200
    assert_equal JSON.parse(last_response.body), "Binary Success"
  end

  it 'handles any error while destroying inside generic handler' do
    status :delete, id: 2

    assert_equal last_response.status, 422
    assert_equal JSON.parse(last_response.body), {"error"=>"Binary Failure"}
  end
end
