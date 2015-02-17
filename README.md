# CoLIn

**Co**mmand **L**ine **In**terface.

## Usage

Colin's main focus is to parse command line arguments, but it's not constrained by it.

You can parse any array and get an options hash back.

To parse an array, just pass it as the only argument to `Colin::Parser#new`.

Let's see an example:

```ruby
  require "colin"
  
  args = %w[first --name=Federico --age 100 second -y 2015 -f -nnumber]
  
  cli = Colin::Parser.new(args)
  
  cli.options
  # => {:name=>"Federico", :age=>100, :y=>2015, :f=>true, :n=>"number"}
  
  cli.args
  # => ["first", "second"]
```

If you want to assign names to the remaining arguments, you can call the `#named_options` method.

It receives an array with the names for the remaining options and it removes as many remaining options as elements there are on the array.

```ruby
  require "colin"
  
  args = %w[first --name=Federico --age 100 second -y 2015 -f -nnumber third]
  
  cli = Colin::Parser.new(args)
  cli.named_options([:do, :dont])
  
  cli.options
  # => {:name=>"Federico",
  #     :age=>100,
  #     :y=>2015,
  #     :f=>true,
  #     :n=>"number",
  #     :do=>"first",
  #     :dont=>"second"}
  
  cli.args
  # => ["third"]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'colin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install colin

## Contributing

1. Fork it ( https://github.com/[my-github-username]/colin/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
