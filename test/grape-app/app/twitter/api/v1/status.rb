module Twitter
  class API::V1::Status < API::V1
    desc 'Return a status.'
    compile_endpoint(::Status::Operation::Show).
      output(:success)    { |_ctx, api:, model:, **| api.body(text: model.text) }.
      output(:not_found)  { |_ctx, api:, params:, **| api.error!("#{params[:id]} is invalid!", 404) }

    get do
      run_endpoint ::Status::Operation::Show
    end

    desc 'Create a status.'
    compile_endpoint(::Status::Operation::Create)

    post do
      run_endpoint ::Status::Operation::Create, domain_ctx: { representer_class: ::Status::Representer::Show }
    end

    desc 'Destroy a status.'
    compile_endpoint(::Status::Operation::Destroy).
      output(:success) do |_ctx, api:, **|
        api.body("Binary Success")
      end.Or do |_ctx, api:, **|
        api.error!("Binary Failure", 422)
      end

    delete do
      run_endpoint ::Status::Operation::Destroy, domain_ctx: { representer_class: ::Status::Representer::Show }
    end
  end
end
