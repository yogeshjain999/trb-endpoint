module Twitter
  class API::V1::Timeline < Grape::API
    include API::Endpoint::Defaults

    compile_endpoint :public, domain: Timeline::Operation::Public, protocol: API::Endpoint::Protocol::NoAuth
    compile_endpoint :home,   domain: Timeline::Operation::Personal

    helpers do
      # Custom domain options to be passed in all the endpoints
      # defined under this API only.
      def default_domain_ctx
        {
          params: params,
          representer_class: Timeline::Representer::Index
        }
      end
    end

    desc 'Return a public timeline.'
    get(:public) do
      run_endpoint(:public)
    end

    desc 'Return a personal timeline.'
    get(:home) do
      run_endpoint(:home)
    end
  end
end
