# Topdown

Welcome to your new gem! In this directory, you'll find the files you need to be
able to package up your Ruby library into a gem. Put your Ruby code in the file
`lib/topdown`. To experiment with that code, run `bin/console` for an
interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'topdown'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install topdown

## Usage

```ruby
Topdown::Service
  .call(context) { puts context }

Topdown::Service
  .expect(contract)
  .call(context) { puts context }
  
Topdown::Service
  .expect(contract)
  .call(context) { puts context }
  

Topdown::Pipeline
  .expect(contract)
  .steps(service1, service2)
  .call(context)

Topdown::Pipeline
  .expect(contract)
  .step(service1)
  .step(service2)
  .call(context)
```

```ruby
class Flow
  include Topdown::Service
  
  CONTRACT = %i(:a, :b, :c)
  
  expect(CONTRACT)
  
  def call
    puts context  
  end
end

Flow.call(a: 1, b: 2, c: 3)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/spurtli/topdown.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
