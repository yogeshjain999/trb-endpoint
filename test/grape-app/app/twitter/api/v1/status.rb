module Twitter
  class API::V1::Status < Grape::API 
    include API::Endpoint::Defaults

    compile_endpoint(Status::Operation::Show).
      output(:success)    { |_ctx, api:, model:, **| api.body(text: model.text) }.
      output(:not_found)  { |_ctx, api:, params:, **| api.error!("#{params[:id]} is invalid!", 404) }

    compile_endpoint Status::Operation::Create

    desc 'Return a status.'
    get do
      run_endpoint Status::Operation::Show
    end

    desc 'Create a status.'
    post do
      run_endpoint Status::Operation::Create, domain_ctx: { representer_class: Status::Representer::Show }
    end
  end
end
