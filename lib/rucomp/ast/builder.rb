# encoding: utf-8
# frozen_string_literal: true

module Rucomp
  module Ast
    class Builder < Parser::Builders::Default
      def n(type, children, source_map)
        Rucomp::Ast::Node.new(type, children, location: source_map)
      end
    end
  end
end
