include_class('ioke.lang.Runtime') { 'IokeRuntime' } unless defined?(IokeRuntime)

import Java::java.io.StringReader unless defined?(StringReader)

describe "Text" do 
  describe "'=='" do 
    it "should return true for the same text" do 
      ioke = IokeRuntime.get_runtime()
      ioke.evaluate_string("x = \"foo\". x == x").should == ioke.true
      ioke.evaluate_string("x = \"\". x == x").should == ioke.true
      ioke.evaluate_string("x = \"34tertsegdf\ndfgsdfgd\". x == x").should == ioke.true
    end

    it "should not return true for unequal texts" do 
      ioke = IokeRuntime.get_runtime()
      ioke.evaluate_string("\"foo\" == \"bar\"").should == ioke.false
      ioke.evaluate_string("\"foo\" == \"sdfsdgdfgsgf\nadsfgdsfgsdfgdfg\nsdfgdsfgsdfg\"").should == ioke.false
    end

    it "should return true for equal texts" do 
      ioke = IokeRuntime.get_runtime()
      ioke.evaluate_string("\"foo\" == \"foo\"").should == ioke.true
      ioke.evaluate_string("\"sdfsdgdfgsgf\nadsfgdsfgsdfgdfg\nsdfgdsfgsdfg\" == \"sdfsdgdfgsgf\nadsfgdsfgsdfgdfg\nsdfgdsfgsdfg\"").should == ioke.true
    end
    
    it "should work correctly when comparing empty text" do 
      ioke = IokeRuntime.get_runtime()
      ioke.evaluate_string("\"\" == \"\"").should == ioke.true
      ioke.evaluate_string("\"a\" == \"\"").should == ioke.false
      ioke.evaluate_string("\"\" == \"a\"").should == ioke.false
    end
  end

  describe "'!='" do 
    it "should return false for the same text" do 
      ioke = IokeRuntime.get_runtime()
      ioke.evaluate_string("x = \"foo\". x != x").should == ioke.false
      ioke.evaluate_string("x = \"\". x != x").should == ioke.false
      ioke.evaluate_string("x = \"34tertsegdf\ndfgsdfgd\". x != x").should == ioke.false
    end

    it "should return true for unequal texts" do 
      ioke = IokeRuntime.get_runtime()
      ioke.evaluate_string("\"foo\" != \"bar\"").should == ioke.true
      ioke.evaluate_string("\"foo\" != \"sdfsdgdfgsgf\nadsfgdsfgsdfgdfg\nsdfgdsfgsdfg\"").should == ioke.true
    end

    it "should return false for equal texts" do 
      ioke = IokeRuntime.get_runtime()
      ioke.evaluate_string("\"foo\" != \"foo\"").should == ioke.false
      ioke.evaluate_string("\"sdfsdgdfgsgf\nadsfgdsfgsdfgdfg\nsdfgdsfgsdfg\" != \"sdfsdgdfgsgf\nadsfgdsfgsdfgdfg\nsdfgdsfgsdfg\"").should == ioke.false
    end
    
    it "should work correctly when comparing empty text" do 
      ioke = IokeRuntime.get_runtime()
      ioke.evaluate_string("\"\" != \"\"").should == ioke.false
      ioke.evaluate_string("\"a\" != \"\"").should == ioke.true
      ioke.evaluate_string("\"\" != \"a\"").should == ioke.true
    end
  end
  
  describe "'[]'" do 
    it "should have tests"
  end
  
  describe "interpolation" do 
    it "should have tests"
  end
  
  describe "escapes" do 
    describe "text escape", :shared => true do 
      it "should be replaced when it's the only thing in the text" do 
        ioke = IokeRuntime.get_runtime
        ioke.evaluate_string('"' + @replace + '"').data.text.should == "#{@expect}"
      end

      it "should be replaced when it's at the start of the text" do 
        ioke = IokeRuntime.get_runtime
        ioke.evaluate_string('"' + @replace + ' "').data.text.should == "#{@expect} "
        ioke.evaluate_string('"' + @replace + 'arfoo"').data.text.should == "#{@expect}arfoo"
      end

      it "should be replaced when it's at the end of the text" do 
        ioke = IokeRuntime.get_runtime
        ioke.evaluate_string('" ' + @replace + '"').data.text.should == " #{@expect}"
        ioke.evaluate_string('"arfoo' + @replace + '"').data.text.should == "arfoo#{@expect}"
      end

      it "should be replaced when it's in the middle of the text" do 
        ioke = IokeRuntime.get_runtime
        ioke.evaluate_string('" ' + @replace + ' "').data.text.should == " #{@expect} "
        ioke.evaluate_string('"ar' + @replace + 'foo"').data.text.should == "ar#{@expect}foo"
      end

      it "should be replaced when there are several in a string" do 
        ioke = IokeRuntime.get_runtime
        ioke.evaluate_string('"' + @replace + ' ' + @replace + ' adsf' + @replace + 'gtr' + @replace + 'rsergfg' + @replace + '' + @replace + '' + @replace + 'fert' + @replace + '"').data.text.should == "#{@expect} #{@expect} adsf#{@expect}gtr#{@expect}rsergfg#{@expect}#{@expect}#{@expect}fert#{@expect}"
      end
    end
    
    describe "\\b" do 
      before :each do 
        @replace = '\b'
        @expect = "\b"
      end

      it_should_behave_like "text escape"
    end

    describe "\\t" do 
      before :each do 
        @replace = '\t'
        @expect = "\t"
      end

      it_should_behave_like "text escape"
    end

    describe "\\n" do 
      before :each do 
        @replace = '\n'
        @expect = "\n"
      end

      it_should_behave_like "text escape"
    end

    describe "\\f" do 
      before :each do 
        @replace = '\f'
        @expect = "\f"
      end

      it_should_behave_like "text escape"
    end

    describe "\\r" do 
      before :each do 
        @replace = '\r'
        @expect = "\r"
      end

      it_should_behave_like "text escape"
    end

    describe "\\\"" do 
      before :each do 
        @replace = '\"'
        @expect = '"'
      end

      it_should_behave_like "text escape"
    end

    describe "\\#" do 
      before :each do 
        @replace = '\#'
        @expect = '#'
      end

      it_should_behave_like "text escape"
    end

    describe "\\\\" do 
      before :each do 
        @replace = '\\\\'
        @expect = '\\'
      end

      it_should_behave_like "text escape"
    end

    describe "\\\\n" do 
      before :each do 
        @replace = "\\\n"
        @expect = ''
      end

      it_should_behave_like "text escape"
    end

    describe "unicode" do 
      it "should have tests"
    end

    describe "octal" do 
      it "should have tests"
    end
  end
end
