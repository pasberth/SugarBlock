require 'spec_helper'

describe do

  subject { Object.new.tap { |o| o.extend SugarBlock::AllSugars } }

  example do

    subject.instance_eval do
      |; a|

      match "hoge" do
        case?("foo") { a = "bar" }
        a.should == nil
        
        case?("hoge") { a = "fuga" }
        a.should == "fuga"
          
        case?("hoge") { a = "fuga2" }
        a.should == "fuga"
      end

      a.should == "fuga"
    end
  end

  example do

    subject.instance_eval do
      (match "hoge" do
        case?("foo" => "bar")
        case?("hoge" => "fuga")
        case?("hoge" => "fuga2")
      end).should == "fuga"
    end
  end

  example do
    subject.instance_eval do
      (match "hoge" do
        case?("foo", "hoge") { "piyo" }
        case?("hoge" => "fuga")
      end).should == "piyo"
    end
  end

  example "Class matching" do

    subject.instance_eval do
      (match ["this is array"] do
        case?(Symbol) { :symbol }
        case?(Hash) { :hash }
        case?(Array) { :array }
      end).should == :array
    end
  end

  example "Class matching" do

    subject.instance_eval do
      (match ["this is array"] do
        case?(Symbol => :symbol)
        case?(Hash => :hash)
        case?(Array => :array)
      end).should == :array
    end
  end

  example "Finally process" do
    subject.instance_eval do
      |; a|
      match "hoge" do
        case?("hoge") { a = "fuga" }
        a.should == "fuga"

        # finally process
        a = "piyo"
        a.should == "piyo"
      end
    end
  end

  example do
    expect { subject.case?("dummy") }.should raise_error NoMethodError
  end

  example do
    expect { subject.match("dummy") {} }.should_not raise_error
  end

  example do
    expect { subject.match("dummy") {} }.should_not raise_error
    expect { subject.case?("dummy") }.should raise_error NoMethodError
  end

  example do
    expect { subject.match("dummy") { subject.case?("dummy") {} } }.should_not raise_error
  end
end
