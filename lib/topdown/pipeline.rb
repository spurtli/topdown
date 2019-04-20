# frozen_string_literal: true

module Topdown
  class Pipeline
    class << self
      def create
        new
      end

      def step(service)
        new.step(service)
      end

      def steps(*args)
        new.steps(*args)
      end

      def expect(*args)
        new.expect(*args)
      end
    end

    def initialize
      @steps = []
    end

    def step(service)
      @steps << service
      self
    end

    def steps(*services)
      @steps += services
      self
    end

    def expect(*args)
      @contract = args
      self
    end

    def call(context = {})
      context = ensure_context(context)
      @steps.reduce(context) do |ctx, service|
        result = service.call(ctx)
        return result if result.failure?
        result
      end
    end

    private

    def ensure_contract(context)
      @contract || context.keys
    end

    def ensure_context(context)
      if context.is_a?(Context)
        context
      else
        Context.build(context, expects: ensure_contract(context))
      end
    end
  end
end
