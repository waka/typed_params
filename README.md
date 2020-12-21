# Typed::Params

Writing...

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'typed-params'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install typed-params

## Usage

Write type to RBS file.

```
class Foo
  class IndexRequest < Struct
    attr_reader name: String
    attr_reader age: Integer
    attr_reader job: Job

    def initialize: (name: String, age: Integer, job: Job) -> void
  end

  private

  class Job < Struct
    attr_reader title: String
    attr_reader grade: Integer

    def initialize: (title: String, grade: Integer) -> void
  end
end
```

In your controller.

```
class FooController
  rescue_from TypeParams::InvalidTypeError, with: :request_error_handler

  def index
    index_params = typed_params(params, 'Foo::IndexRequest')
    response = some_resources(index_params)
    render json: response status: :ok
  end

  private

  def request_error_handler
    render json: { error: 'invalid request' }, status: :bad_request
  end
end
```

In your service.

```
class FooService
  include TypedParams

  def initialize(params)
    @params = typed_params(params, 'Foo::IndexRequest')
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/waka/typed-params.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
