require 'sugar_block/nestable'

module SugarBlock

  class SyntaxBlock
    
    attr_reader :parent
    attr_reader :args

    def initialize parent, &body
      @parent = parent
      @body = body
    end

    def call *args, &block
      if @body
        @body.call *args, &block
      else
        fail
      end
    end
    
    def to_proc
      method(:call).to_proc
    end
  end

  class NestedBlock < SyntaxBlock

    include Nestable
  end
end
