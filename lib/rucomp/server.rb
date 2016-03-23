# encoding: utf-8
# frozen_string_literal: true
require 'rucomp/server/request'
require 'rucomp/server/request_objects'
require 'rucomp/server/logger'

require 'thin'
require 'fileutils'
require 'dalli'

module Rucomp
  class Server
    attr_reader :port, :addr, :log_to_stdout, :log_file
    def initialize(options = {})
      @port = options[:port] || 35_687
      @addr = options[:addr] || '127.0.0.1'
      @log_to_stdout = options[:log_to_stdout]
      @log_file = @log_to_stdout ? $stdout : options[:log_file] || '~/.rucomp/server.log' # rubocop:disable Metrics/LineLength
      @secret_file = options[:secret_file]
      init_logging
      @dalli_client = Dalli::Client.new('localhost:11211', compress: true)
    end

    def call(_env)
      [200, { 'Content-Type' => 'text/plain' }, ['Hello from Rack!']]
    end

    def start
      puts 'Starting server...'
      puts "Listening on #{addr}:#{port}"
      puts "Writing logs to #{log_file}"
      Rack::Server.start(app: self, port: port)
    end

    private

    def init_logging
      _create_log_dir
      Logger.options = {
        device: log_file,
        template: ':time - :severity - :message',
        time_format: '%H:%S:%M',
        level: :info
      }
      Logger.reset_logger
    end

    def _create_log_dir
      return if @log_to_stdout
      logdir = File.dirname(log_file)
      FileUtils.mkdir_p(logdir) unless File.directory?(logdir)
    end
  end
end
