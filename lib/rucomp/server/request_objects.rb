# encoding: utf-8
# frozen_string_literal: true
require 'json'

module Rucomp
  class Server
    class Buffer
      def initialize(file_path = nil, contents = nil)
        @file_path = file_path
        @contents = contents
      end

      def self.from_json(json_obj)
        json = JSON.parse(json_obj)
        new(json['file_path'], json['contents'])
      end
    end

    class QueryRequest
      def initialize(file_path = nil, buffers = [], line = 0, column = 0)
        @file_path = file_path
        @buffers = buffers
        @line = line
        @column = column
      end

      def self.from_json(json_obj)
        json = JSON.parse(json_obj)
        buffers = []
        if json['buffers'] && !json['buffers'].empty?
          json['buffers'].each do |buf|
            buffers.push Buffer.from_json(buf)
          end
        end
        new(json['file_path'], buffers, json['line'], json['column'])
      end
    end
  end
end
