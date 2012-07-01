# -*- coding: utf-8 -*-
require 'spec_helper'

describe SugarReciever do

  example "block case." do

    subject.instance_eval do
      |; a|

      match "hoge" do
        case?("foo") { a = "bar" }
        case?("hoge") { a = "fuga" }
        case?("hoge") { a = "fuga2" }
      end

      a.should == "fuga"
    end
  end

  example "hash case." do

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

  context "Class matching" do
    example "block cases." do

      subject.instance_eval do
        (match ["this is array"] do
           case?(Symbol) { :symbol }
           case?(Hash) { :hash }
           case?(Array) { :array }
         end).should == :array
      end
    end

    example "hash cases." do

      subject.instance_eval do
        (match ["this is array"] do
           case?(Symbol => :symbol)
           case?(Hash => :hash)
           case?(Array => :array)
         end).should == :array
      end
    end
  end

  context "Default process" do

    example do
      subject.instance_eval do
        |; a|

        (match "hoge" do
           case?("foo") { a = "bar" }
           default { |_| a = _ }
         end).should == "hoge"

        a.should == "hoge"
      end
    end
  end

  context "Finally process" do

    example "about the return value and finally process." do

      subject.instance_eval do
        |; a|
  
        (match "hoge" do
          case?("hoge") { a.should == nil; a = "fuga" }
          finally { a.should == "fuga"; a = "piyo" }
        end).should == "fuga"
        
        a.should == "piyo"
      end
    end


    example "about raising error." do
      |; a|
      expect do
        subject.instance_eval do
          match "hoge" do
            case?("hoge") { raise TypeError }
            finally do
              # this code will execute in all times finally.
              a = "piyo"
            end
          end
        end
      end.should raise_error TypeError

      a.should == "piyo"
    end
  end
end
