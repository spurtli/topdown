# frozen_string_literal: true

module Topdown
  class Failure < StandardError
    attr_reader :context

    def initialize(context = nil)
      @context = context
      super
    end

    def message
      super + "\n" + backtrace.first
    end
  end

  class ContextError < StandardError
    attr_reader :context

    def initialize(message, context = nil)
      @context = context
      super(message)
    end

    def message
      super + "\n" + backtrace.first
    end
  end

  class CallError < StandardError
    def message
      'No call method defined or block given.'
    end
  end

  class NullError
    def message
      'NullError is not an error'
    end
  end
end
