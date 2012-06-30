
module SugarBlock::Block

  module Nestable

    def method_missing keyword, *args, &block
      if @__current_block
        @__current_block.send :method_missing, keyword, *args, &block
      elsif has_block? keyword
        syntax_block = create_block(keyword)
        begin_block! syntax_block
        result = syntax_block.call(*args, &block)
        end_block!
        result
      else
        super
      end
    end

    def has_block? keyword
      if @__current_block
        @__current_block.respond_to? :has_block? and @__current_block.has_block? keyword
      else
        respond_to? keyword
      end
    end

    def create_block keyword
      if !@__current_block and respond_to? keyword
        SyntaxBlock.new(self, &method(keyword))
      else
        raise NotImplementedError
      end
    end

    def begin_block! block
      raise "block already beginning." if @__current_block
      @__current_block = block
      true
    end

    def end_block!
      @__current_block = nil
      true
    end
  end
  
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
