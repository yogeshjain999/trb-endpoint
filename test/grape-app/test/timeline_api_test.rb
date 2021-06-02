require_relative "test_helper"

class TimelineApiTest < Minitest::Spec
  it 'returns an empty response for no limit' do
    get "/v1/timeline/public"

    assert_equal last_response.status, 200
    assert_equal JSON.parse(last_response.body), []
  end

  it 'returns public timeline' do
    get "/v1/timeline/public", limit: 3

    assert_equal last_response.status, 200
    assert_equal JSON.parse(last_response.body), [
      {"id"=>3, "text"=>"tweet-3"},
      {"id"=>2, "text"=>"tweet-2"},
      {"id"=>1, "text"=>"tweet-1"}
    ]
  end

  it 'returns personal timeline' do
    header 'api-key', 'secret'
    get "/v1/timeline/home", limit: 3

    assert_equal last_response.status, 200
    assert_equal JSON.parse(last_response.body), [
      {"id"=>3, "text"=>"tweet-3"},
      {"id"=>2, "text"=>"tweet-2"},
      {"id"=>1, "text"=>"tweet-1"}
    ]
  end

  it 'returns 401 for invalid api-key' do
    header 'api-key', 'wrong'
    get "/v1/timeline/home", limit: 3

    assert_equal last_response.status, 401
  end
end
