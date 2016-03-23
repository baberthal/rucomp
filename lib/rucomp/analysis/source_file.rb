# encoding: utf-8
# frozen_string_literal: true
require 'digest/md5'
require 'rucomp/error'

module Rucomp
  module Analysis
    class SourceFile
      STRING_SOURCE_NAME = '(string)'.freeze

      attr_reader :path, :buffer, :ast, :comments, :tokens, :diagnostics,
                  :parser_error, :raw_source, :ruby_version

      def self.from_file(path, ruby_version)
        file = File.read(path)
        new(file, ruby_version, path)
      rescue Errno::ENOENT
        raise Rucomp::Error, "No such file or directory: #{path}"
      end

      def initialize(source, ruby_version, path = nil)
        unless source.encoding == Encoding::UTF_8
          source.force_encoding(Encoding::UTF_8)
        end

        @raw_source = source
        @path = path
        @diagnostics = []
        @ruby_version = ruby_version

        parse(source, ruby_version)
      end

      def ast_with_comments
        return if !ast || !comments
        @ast_with_comments ||= Parser::Source::Comment.associate(ast, comments)
      end

      def lines
        @lines ||= begin
          all_lines = @buffer.source_lines
          last_token_line = tokens.any? ? tokens.last.pos.line : all_lines.size
          result = []
          all_lines.each_with_index do |line, idx|
            break if idx >= last_token_line && line == '__END__'
            result << line
          end
          result
        end
      end

      def [](*args)
        lines[*args]
      end

      def valid_syntax?
        return false if @parser_error
        @diagnostics.none? { |d| [:error, :fatal].include?(d.level) }
      end

      def checksum
        Digest::MD5.hexdigest(@raw_source)
      end

      private

      def parse(source, ruby_version)
        buffer_name = @path || STRING_SOURCE_NAME
        @buffer = Parser::Source::Buffer.new(buffer_name, 1)

        begin
          @buffer.source = source
        rescue EncodingError => e
          @parser_error = e
          return
        end

        parser = create_parser(ruby_version)

        begin
          @ast, @comments, tokens = parser.tokenize(@buffer)
          @ast.complete! if @ast
        rescue Parser::SyntaxError # rubocop:disable Lint/HandleExceptions
          # All errors are diagnostics at this point, no need to do anything
        end

        @tokens = tokens.map { |t| Token.from_parser_token(t) } if tokens
      end

      def parser_class(ruby_version)
        case ruby_version.to_f
        when 1.9
          require 'parser/ruby19'
          Parser::Ruby19
        when 2.0
          require 'parser/ruby20'
          Parser::Ruby20
        when 2.1
          require 'parser/ruby21'
          Parser::Ruby21
        when 2.2
          require 'parser/ruby22'
          Parser::Ruby22
        when 2.3
          require 'parser/ruby23'
          Parser::Ruby23
        else
          raise ArgumentError, "Unknown Ruby version: #{ruby_version.inspect}"
        end
      end

      def create_parser(ruby_version)
        builder = Rucomp::Ast::Builder.new

        parser_class(ruby_version).new(builder).tap do |parser|
          parser.diagnostics.all_errors_are_fatal = (RUBY_ENGINE != 'ruby')
          parser.diagnostics.ignore_warnings = false
          parser.diagnostics.consumer = ->(diag) { @diagnostics << diag }
        end
      end
    end
  end
end
