require 'thor/core_ext/hash_with_indifferent_access'
require 'forwardable'

module Rucomp
  class Logger
    class Options < Thor::CoreExt::HashWithIndifferentAccess
      def initialize(opts = {}, defaults = {})
        super(defaults.merge(opts || {}))
      end
    end

    class << self
      extend Forwardable

      def_delegators :logger, :debug, :debug?, :error, :error?, :fatal, :fatal?,
                     :flush, :formatter, :info, :info?, :level, :level=, :warn,
                     :warn?, :unknown, :silence

      def logger
        @logger ||= begin
                      require 'lumberjack'
                      Lumberjack::Logger.new(
                        options.fetch(:device) { $stderr },
                        options)
                    end
      end

      def reset_logger
        @logger = nil
      end

      def options
        @options ||= Options.new(
          level: :info,
          template: ':time - :severity - :message',
          time_format: '%H:%M:%S')
      end

      def options=(new_opts)
        @options = Options.new(new_opts)
      end
    end
  end
end
