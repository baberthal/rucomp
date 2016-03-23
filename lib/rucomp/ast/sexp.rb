# encoding: utf-8
# frozen_string_literal: true

module Rucomp
  module Ast
    module Sexp
      def s(type, *children)
        Rucomp::Ast::Node.new(type, children)
      end
    end
  end
end
