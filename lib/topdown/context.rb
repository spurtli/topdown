# frozen_string_literal: true

module Topdown
  class Context < Struct
    class << self
      def build(context, expects: [])
        return context if context.is_a?(self)

        context = new(
          *(expects << :error),
          keyword_init: true
        ).new(context.merge(error: NullError.new))

        # validation
        expects.each do |key|
          next if key == :error

          if context[key].nil?
            raise ContextError.new(
              "Value for ':#{key.to_s}' is required",
              context
            )
          end
        end

        context
      rescue ContextError => err
        context.fail!(err)
      rescue => err
        context = nil_context(context)
        context.fail!(err)
      end

      private

      def nil_context(context)
        new(
          *(context.keys << :error)
        ).new(context.keys.map {nil})
      end
    end

    attr_reader :error

    def success?
      !failure?
    end

    def failure?
      @failure || false
    end

    def fail!(message)
      self.error = message
      @failure = true
      raise Failure, self
    end

    def inspect
      pairs = each_pair
        .map {|pair| pair[0].to_s + ':' + pair[1].to_s}
        .join(', ')

      "<Context #{pairs}>"
    end
  end
end
