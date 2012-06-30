# -*- coding: utf-8 -*- 

require 'spec_helper'

describe SugarReciever do

  context "wrong cases." do

    it "should be raised when not onto the match block." do
      expect { subject.case?("dummy") }.should raise_error NoMethodError
    end

    it "can't nest of the 'case?' method." do
      subject.match("dummy") do
        subject.case?("dummy") do
          pending "ネスと不可能にする意味ある？"  do
            expect { subject.case?("dummy") {} }.should raise_error NoMethodError
          end
        end
      end
    end
  end

  context "right cases." do

    example do
      expect { subject.match("dummy") {} }.should_not raise_error
    end

    example do
      expect { subject.match("dummy") { subject.case?("dummy") {} } }.should_not raise_error
    end

    example do
      subject.match("dummy") do
        subject.case?("dummy") do
          expect { subject.match("dummy"){} }.should_not raise_error
        end
      end
    end
  end

  context "side effect should not exist." do

    example do
      expect { subject.match("dummy") {} }.should_not raise_error
      expect { subject.case?("dummy") }.should raise_error NoMethodError
    end
  end
end
