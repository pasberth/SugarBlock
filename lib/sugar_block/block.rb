
module SugarBlock::Block

  module Nestable

    def method_missing keyword, *args, &block
      if current_block and
        ( begin
            return current_block.send :method_missing, keyword, *args, &block
          rescue NoMethodError; end )
      elsif has_block? keyword
        syntax_block = create_block(keyword)
        begin_block! syntax_block
        result = syntax_block.call(*args, &block)
        end_block! syntax_block
        result
      else
        super
      end
    end

    def has_block? keyword
      if current_block and
          current_block.respond_to? :has_block? and current_block.has_block? keyword
      else
        respond_to? keyword
      end
    end

    private

    def create_block keyword
      if current_block and current_block.has_block? keyword
        current_block.create_block(keyword)
      elsif has_block? keyword
        SyntaxBlock.new(self, &method(keyword))
      else
        raise NotImplementedError
      end
    end

    def begin_block! block
      raise "block already beginning." if sugar_blocks.include?(block)
      sugar_blocks << block
      true
    end

    def end_block! block
      raise "tried to close outer block." if sugar_blocks.last != block
      sugar_blocks.pop
      true
    end

    def current_block
      sugar_blocks.last
    end

    def sugar_blocks
      @__sugar_blocks ||= []
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
