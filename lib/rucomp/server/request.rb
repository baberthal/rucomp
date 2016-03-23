# encoding: utf-8
# frozen_string_literal: true
require 'rack/request'

module Rucomp
  class Server
    class Request
      attr_reader :rack, :endpoint, :verified
      def initialize(env)
        @rack = Rack::Request.new(env)
        @endpoint = parse_endpoint
        verify_request unless @endpoint == :bad_request
      end

      private

      def parse_endpoint
        case @rack.path_info
        when '/find_definition' then :find_definition
        when '/list_completions' then :list_completions
        when '/ping' then :ping
        else :bad_request
        end
      end

      def verify_request
        return _verify_find_defs if @endpoint == :find_definition
        return _verify_list_comps if @endpoint == :list_completions
        _verify_ping
      end

      def _verify_find_defs
        @verified = @rack.post?
      end

      def _verify_list_comps
        @verified = @rack.post?
      end

      def _verify_ping
        @verified = @rack.get?
      end
    end
  end
end
