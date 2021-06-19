# frozen_string_literal: true

require "test_helper"

class Trailblazer::EndpointTest < Minitest::Spec
  class AdminsController < ApplicationController
    compile_endpoint(Operation::New, protocol: ApplicationProtocol::WithAuthorization).
      output(:success) { |_ctx, controller:, model:, **| controller.render(:success, "success from DSL") }.
      output(:unauthorized) { |_ctx, controller:, **| controller.render(:unauthorized, "unauthorized from DSL") }

    compile_endpoint Operation::Create, protocol: ApplicationProtocol::WithAuthorization
    compile_endpoint Operation::Update

    def new
      run_endpoint Operation::New
    end

    def create
      run_endpoint Operation::Create
    end

    def update
      run_endpoint Operation::Update
    end
  end

  let(:user)                { User.new(1, "admin") }
  let(:controller)          { AdminsController.new(user) }

  let(:invalid_user)        { User.new(2, "employee") }
  let(:invalid_controller)  { AdminsController.new(invalid_user) }

  it "new: success" do
    signal, (ctx, _) = controller.new

    assert_equal signal.inspect, "#<Trailblazer::Activity::End semantic=:success>"
    assert_equal controller.status, :success
    assert_equal controller.message, "success from DSL"
    assert_equal ctx[:domain_ctx][:model], User.new
  end

  it "new: unauthorized" do
    signal, _ = invalid_controller.new

    assert_equal signal.inspect, "#<Trailblazer::Activity::End semantic=:unauthorized>"
    assert_equal invalid_controller.status, :unauthorized
    assert_equal invalid_controller.message, "unauthorized from DSL"
  end

  it "create: unauthenticated" do
    controller = AdminsController.new(nil)
    signal, _ = controller.create

    assert_equal signal.inspect, "#<Trailblazer::Activity::End semantic=:unauthenticated>"
    assert_equal controller.status, :unauthenticated
  end

  it "create: unauthorized" do
    signal, (ctx, flow_options) = invalid_controller.create

    assert_equal signal.inspect, "#<Trailblazer::Activity::End semantic=:unauthorized>"
    assert_equal invalid_controller.status, :unauthorized
    assert_equal invalid_controller.message, "2 isn't allowed access!"

    assert_nil ctx[:domain_ctx][:model]

    assert_equal flow_options, {
      context_options: {
        aliases: { "contract.default": :contract, "policy.default": :policy },
        container_class: Trailblazer::Context::Container::WithAliases
      }
    }
  end

  it "create: invalid_data" do
    controller.params = { id: 1, role: nil }
    signal, (ctx, _) = controller.create

    assert_equal signal.inspect, "#<Trailblazer::Activity::End semantic=:invalid_data>"
    assert_equal controller.status, :invalid_data
    assert_equal controller.message, ["Role must be filled"]

    assert_equal ctx[:domain_ctx][:model], User.new
    assert_equal ctx[:domain_ctx][:current_user], controller.current_user
    assert_equal ctx[:domain_ctx][:params], { id: 1, role: nil }
    assert_equal ctx[:endpoint_ctx][:controller], controller
    assert_equal ctx[:controller], controller
  end

  it "create: success" do
    controller.params = { id: 1, role: "admin" }
    signal, (ctx, _) = controller.create

    assert_equal signal.inspect, "#<Trailblazer::Activity::End semantic=:success>"
    assert_equal controller.status, :success

    assert_equal ctx[:domain_ctx][:model], User.new
    assert_equal ctx[:domain_ctx][:current_user], controller.current_user
    assert_equal ctx[:domain_ctx][:params], { id: 1, role: "admin" }
    assert_equal ctx[:endpoint_ctx][:controller], controller
    assert_equal ctx[:controller], controller
  end

  it "update: not_found" do
    controller.params = { id: 2 }
    signal, (ctx, _) = controller.update
    assert_equal controller.status, :not_found

    assert_equal signal.inspect, "#<Trailblazer::Activity::End semantic=:not_found>"
    assert_equal ctx[:domain_ctx][:params], { id: 2 }
    assert_nil ctx[:domain_ctx][:model]
  end

  it "update: :unauthorized" do
    controller.params = { id: 3 }
    signal, (ctx, _) = controller.update
    assert_equal controller.status, :unauthorized

    assert_equal signal.inspect, "#<Trailblazer::Activity::End semantic=:unauthorized>"
    assert_equal ctx[:domain_ctx][:params], { id: 3 }
    assert_equal ctx[:domain_ctx][:model], User.new(3, "admin")
  end
end
