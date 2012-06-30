
$:.unshift File.dirname(__FILE__) + '/../lib'

require 'sugar_block'

class SugarReciever

  include SugarBlock::AllSugars
end
