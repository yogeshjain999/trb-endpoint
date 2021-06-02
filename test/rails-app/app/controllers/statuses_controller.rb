class StatusesController < ApplicationController
  compile_endpoint(Status::Operation::Show).
    output(:success) { |_ctx, controller:, model:, **| controller.render(plain: model.text) }.
    output(:not_found) { |_ctx, controller:, params:, **| controller.render(plain: "#{params[:id]} is invalid!", status: :not_found) }

  compile_endpoint(Status::Operation::Create).
    output(:success) { |_ctx, controller:, model:, **| controller.render(plain: model.text, status: :created) }.
    output(:invalid_data) { |_ctx, controller:, contract:, **| controller.render(plain: contract.errors.full_messages, status: 422) }

  def show
    run_endpoint Status::Operation::Show
  end

  def create
    run_endpoint Status::Operation::Create, domain_ctx: { representer_class: Status::Representer::Show }
  end
end
