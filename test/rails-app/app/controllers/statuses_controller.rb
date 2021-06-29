class StatusesController < ApplicationController
  compile_endpoint Status::Operation::New

  def new
    run_endpoint Status::Operation::New
  end

  compile_endpoint(Status::Operation::Create).
    output(:success) { |_ctx, controller:, model:, **|
      controller.render(plain: model.text, status: :created)
    }.
    output(:invalid_data) { |_ctx, controller:, contract:, **|
      controller.render(plain: contract.errors.full_messages, status: 422)
    }

  def create
    run_endpoint Status::Operation::Create, domain_ctx: { representer_class: Status::Representer::Show }
  end

  compile_endpoint(Status::Operation::Show).
    output(:success) { |_ctx, controller:, model:, **|
      controller.render(plain: model.text)
    }.
    output(:not_found) { |_ctx, controller:, params:, **|
      controller.render(plain: "#{params[:id]} is invalid!", status: :not_found)
    }

  def show
    run_endpoint Status::Operation::Show
  end

  compile_endpoint(Status::Operation::Destroy) { |_ctx, api:, **|
    api.body("Binary Success")
  }.Or { |_ctx, api:, **|
    api.error!("Binary Failure", 422)
  }

  def destroy
    run_endpoint Status::Operation::Destroy, domain_ctx: { representer_class: Status::Representer::Show }
  end
end
