require 'rucomp/server/request'
require 'rucomp/server/request_objects'
require 'rack'
require 'fileutils'

module Rucomp
  class Server
    attr_reader :port, :addr, :ruby_src_path, :log_to_stdout, :log_file
    def initialize(options = {})
      @port = options[:port]
      @addr = options[:addr]
      @ruby_src_path = options[:ruby_src_path]
      @log_to_stdout = options[:logging]
      @log_file = @log_to_stdout ? $stdout : options[:log_file]
      @secret_file = options[:secret_file]
      init_logging
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
      logdir = File.dirname(log_file)
      return if File.directory?(logdir)
      FileUtils.mkdir_p(logdir)
    end
  end
end
