require "spec_helper"
require "colin"

def Parser(options={})
  Colin::Parser.new(options)
end

scope Colin::Parser do
  scope "#options" do
    scope "empty array" do
      let(:parser) { Parser([]) }
      spec { parser.options == {} }
      spec { parser.args == [] }
    end

    scope "unnamed attributes" do
      let(:parser) { Parser( %w[first second] ) }
      spec { parser.options == {} }
      spec { parser.args == %w[first second] }
    end

    scope "double dashed attributes" do
      scope "space" do
        let(:parser) { Parser( %w[--name NAME] ) }
        spec { parser.options == {name: "NAME"} }
        spec { parser.args == [] }
      end

      scope "=" do
        let(:parser) { Parser( %w[--name=NAME] ) }
        spec { parser.options == {name: "NAME"} }
        spec { parser.args == [] }
      end
    end

    scope "single dashed attributes" do
      scope "space" do
        let(:parser) { Parser( %w[-n NAME] ) }
        spec { parser.options == {n: "NAME"} }
        spec { parser.args == [] }
      end

      scope "=" do
        let(:parser) { Parser( %w[-nNAME] ) }
        spec { parser.options == {n: "NAME"} }
        spec { parser.args == [] }
      end
    end

    scope "special types" do
      spec "integer" do
        @parser = Parser( %w[--number 78] )
        @parser.options[:number] == 78
      end

      spec "float" do
        @parser = Parser( %w[--number 5.1] )
        @parser.options[:number] == 5.1
      end

      spec "true" do
        @parser = Parser( %w[--flag true] )
        @parser.options[:flag] == true
      end

      spec "false" do
        @parser = Parser( %w[--flag false] )
        @parser.options[:flag] == false
      end

      spec "nil" do
        @parser = Parser( %w[--value nil] )
        @parser.options[:value] == nil
      end

      spec "null" do
        @parser = Parser( %w[--value null] )
        @parser.options[:value] == nil
      end
    end

    scope "flags" do
      spec "dashed true" do
        @parser = Parser( %w[-f] )
        @parser.options[:f] == true
      end

      spec "double dashed true" do
        @parser = Parser( %w[--flag] )
        @parser.options[:flag] == true
      end

      spec "double dashed false" do
        @parser = Parser( %w[--no-flag] )
        @parser.options[:flag] == false
      end
    end

    scope "#named_options" do
      scope "one" do
        let(:parser) { Parser( %w[hello --name NAME] ).named_options(:greeting) }
        spec { parser.options == {name: "NAME", greeting: "hello"} }
        spec { parser.args == [] }
      end

      scope "many" do
        scope "exact" do
          let(:parser) { Parser( %w[hello --name NAME water] ).named_options(:greeting, :liquid) }
          spec { parser.options == {name: "NAME", greeting: "hello", liquid: "water"} }
          spec { parser.args == [] }
        end

        scope "more args than names" do
          let(:parser) { Parser( %w[hello --name NAME water] ).named_options(:greeting) }
          spec { parser.options == {name: "NAME", greeting: "hello"} }
          spec { parser.args == ["water"] }
        end

        scope "more names than args" do
          let(:parser) { Parser( %w[hello --name NAME] ).named_options(:greeting, :liquid) }
          spec { parser.options == {name: "NAME", greeting: "hello"} }
          spec { parser.args == [] }
        end
      end
    end

    scope "combination" do
      let(:parser) { Parser( %w[some_file.rb -nNAME --age=34 -n 90 random_string --other_number 70] ) }
      spec { parser.options == { n: "NAME", age: 34, n: 90, other_number: 70 } }
      spec { parser.args == %w[some_file.rb random_string] }
    end
  end
end
