# frozen_string_literal: true

module Topdown
  class Service
    class << self
      def create(&block)
        new(&block)
      end

      def expect(*args)
        new.expect(*args)
      end

      def call(context = {}, &block)
        new.call(context, &block)
      end
    end

    def initialize(&block)
      @block = block
    end

    def expect(*args)
      @contract = args
      self
    end

    def call(context = {}, &block)
      context = ensure_context(context)
      if block
        run(context, block)
      elsif @block != nil
        run(context, @block)
      else
        context.fail!(error: CallError.new)
      end
      context
    rescue Failure, ContextError => err
      err.context
    rescue => err
      err.context
    end

    def run(context, block)
      block.call(context)
    rescue => err
      ensure_context(context).fail!(err)
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
