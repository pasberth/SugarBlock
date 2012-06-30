$:.unshift File.dirname(__FILE__) + '/../lib'

require 'sugar_block'

include SugarBlock::AllSugars

match "hoge" do
  case? "foo" do
    puts "this code will not be executed."
  end
  
  case? "hoge" do
    puts "this code will be executed."
  end
  
  case? "hoge" do
    puts "this code will be not executed."
  end
end

result = match "hoge" do
  case? "foo" => "bar"
  case? "hoge" => "fuga"
end

p result # => "fuga"
