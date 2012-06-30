
module SugarBlock

  module Sugar

    class MatchBlock < NestedBlock
      def call *args, &block
        @args = args
        block.call
        @result
      end

      def case? *os, &block
        os.each { |o| _case? o, &block }
      end

      private
      def _case? o, &block
        @hit and return
        case o
        when Hash
          res = nil
          if o.keys.any? { |e| e === args[0] ? (res = o[e]; true) : false  }
            @result = res
            @hit = true
            @result
          end
        else
          if o === args[0]
            @result = block.call(o)
            @hit = true
            @result
          end
        end
      end
    end

    module MatchSuger

      include Nestable

      def has_block? keyword
        :match == keyword or super
      end

      def create_block keyword
        :match == keyword && MatchBlock.new(self) or super
      end
    end
  end
end
