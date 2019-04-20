# Topdown

This is a service library. You can use it to create service objects and model
simple flows in pipelines. It allows to create services and pipelines
programmatically or you can define them in classes by including a module.

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

Have a look at the test files.


```ruby
result = Topdown::Service
  .call(a: 0) { context.a = 1 }
result.success?
result.a == 1 # true

result = Topdown::Service
  .create { context.a = 1 }
  .call(a: 0)
result.success?
result.a == 1 # true

result = Topdown::Service
  .create { context.a = 1 }
  .expect(:a)
  .call(a: 0)
result.success?
result.a == 1 # true

result = Topdown::Service
  .create {}
  .expect(:b)
  .call(a: 0)
result.failure? # true

result = Topdown::Service
  .create { raise 'stop' }
  .call
result.failure? # true
result.error.message == 'stop' # true
```

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
