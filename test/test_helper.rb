# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minitest/autorun"

require "trailblazer/endpoint"
require "trailblazer"
require "reform/form/dry"

Minitest::Spec.class_eval do
  User = Struct.new(:id, :role) do
    def self.find_by(id:)
      return if id == 2
      User.new(id, "admin")
    end
  end

  class UserForm < Reform::Form
    feature Reform::Form::Dry

    property :id
    property :role

    validation do
      params do
        required(:role).filled
      end
    end
  end

  class UserPolicy
    def initialize(user, model)
      @user   = user
      @model  = model
    end

    def update?
      @user.id == @model.id
    end
  end

  module Operation
    class New < Trailblazer::Operation
      step Model(User)
    end

    class Create < Trailblazer::Operation
      step Subprocess(New)
      step Contract::Build(constant: UserForm)
      step Contract::Validate(invalid_data_terminus: true)
    end

    class Update < Trailblazer::Operation
      step Model(User, :find_by, not_found_terminus: true)
      # DISCUSS: Accept terminus flag in Pundit ?
      step Policy::Pundit(UserPolicy, :update?), Output(:failure) => End(:unauthorized)
      step Contract::Build(constant: UserForm)
      step Contract::Validate(invalid_data_terminus: true)
    end
  end

  class ApplicationProtocol < Trailblazer::Endpoint::Protocol
    def authenticate(ctx, controller:, domain_ctx:, **)
      domain_ctx[:current_user] = controller.current_user
    end

    class WithAuthorization < Trailblazer::Endpoint::Protocol::WithAuthorization
      def authenticate(ctx, controller:, domain_ctx:, **)
        domain_ctx[:current_user] = controller.current_user
      end

      def authorize(_ctx, domain_ctx:, **)
        domain_ctx[:current_user].role == "admin"
      end
    end
  end

  class ApplicationAdapter < Trailblazer::Endpoint::Adapter
    def unauthenticated(_ctx, controller:, **)
      controller.render(:unauthenticated)
    end

    def unauthorized(_ctx, controller:, domain_ctx:, **)
      controller.render(:unauthorized, "#{domain_ctx[:current_user].id} isn't allowed access!")
    end

    def not_found(_ctx, controller:, **)
      controller.render(:not_found)
    end

    def invalid_data(_ctx, controller:, domain_ctx:, **)
      controller.render(:invalid_data, domain_ctx[:contract].errors.full_messages)
    end

    def failure(_ctx, controller:, domain_ctx:, **)
      controller.render(:failure, domain_ctx[:error])
    end

    def success(_ctx, controller:, **)
      controller.render(:success)
    end
  end

  class ApplicationController
    include Trailblazer::Endpoint

    attr_accessor :current_user, :params, :status, :message

    def initialize(user)
      self.current_user = user
      self.params       = { id: 1 }
    end

    def self.default_endpoint_adapter
      ApplicationAdapter
    end

    def self.default_endpoint_protocol
      ApplicationProtocol
    end

    def render(status, message = "")
      self.status = status
      self.message = message
    end

    def default_endpoint_ctx
      {
        controller: self,
      }
    end

    def default_domain_ctx
      {
        params: params
      }
    end

    def default_flow_options
      {
        context_options: {
          aliases: { 'contract.default': :contract, 'policy.default': :policy },
          container_class: Trailblazer::Context::Container::WithAliases,
        }
      }
    end
  end
end
