require "test_helper"

class TimelineApiTest < ActionDispatch::IntegrationTest
  test 'returns an empty response for no limit' do
    get "/timeline/public"

    assert_response 200
    assert_equal JSON.parse(response.body), []
  end

  test 'returns public timeline' do
    get "/timeline/public", params: { limit: 3 }

    assert_response 200
    assert_equal JSON.parse(response.body), [
      {"id"=>3, "text"=>"tweet-3"},
      {"id"=>2, "text"=>"tweet-2"},
      {"id"=>1, "text"=>"tweet-1"}
    ]
  end

  test 'returns personal timeline' do
    get "/timeline/home", params: { limit: 3 }, headers: { 'api-key' => 'secret' }

    assert_response 200
    assert_equal JSON.parse(response.body), [
      {"id"=>3, "text"=>"tweet-3"},
      {"id"=>2, "text"=>"tweet-2"},
      {"id"=>1, "text"=>"tweet-1"}
    ]
  end

  test 'returns 401 for invalid api-key' do
    get "/timeline/home", params: { limit: 3 }, headers: { 'api-key' => 'wrong' }

    assert_response 401
  end
end
