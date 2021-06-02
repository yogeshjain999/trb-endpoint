require "test_helper"

class StatusApiTest < ActionDispatch::IntegrationTest
  test 'returns status' do
    get "/statuses/1", headers: { 'api-key' => 'secret' }

    assert_response 200
    assert_equal response.body, "1 Punch"
  end

  test 'returns 404 when status is not found' do
    get "/statuses/2", headers: { 'api-key' => 'secret' }

    assert_response 404
    assert_equal response.body, "2 is invalid!"
  end

  test 'creates new status' do
    post "/statuses", params: { text: "Yo!" }, headers: { 'api-key' => 'secret' }

    assert_response 201
    assert_equal response.body, "Yo!"
  end

  test 'returns validation error for invalid input' do
    post "/statuses", headers: { 'api-key' => 'secret' }

    assert_response 422
    assert_equal JSON.parse(response.body), ["Text must be filled"]
  end
end
