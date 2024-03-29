class TimelineController < ApplicationController
  compile_endpoint :public, domain: Timeline::Operation::Public, protocol: ApplicationProtocol::NoAuth
  compile_endpoint :home,   domain: Timeline::Operation::Personal

  def public
    run_endpoint(:public)
  end

  def home
    run_endpoint(:home)
  end

  # Custom domain options to be passed in all the endpoints
  # defined under this API only.
  directive :domain_ctx do
    {
      params: params,
      representer_class: Timeline::Representer::Index
    }
  end
end
