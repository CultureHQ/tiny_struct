# SimpleStruct

Build `Struct` classes that do less. `SimpleStruct` is a very similar concept to `Struct` classes in Ruby, with a few key differences:

* In `Struct` classes all parameters are optional, in `SimpleStruct` they are all required.
* In `Struct` classes each parameter is accessible through an `attr_accessor`, in `SimpleStruct` they are accessible through `attr_reader`s.
* In `Struct` classes you can call all kinds of querying methods on the objects as if they were an enumerable of the various values they represent (e.g., `to_a`, `to_h`, `size`, `[]`, `values_at`, etc.), in `SimpleStruct` none of these methods are defined.

Use `Struct` if you need the flexibility and extra query methods provided by the constructor. If not, consider using `SimpleStruct`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_struct'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_struct

## Usage

```ruby
class User < SimpleStruct.new(:first_name, :last_name)
  def full_name
    "#{first_name} #{last_name}"
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddeisz/simple_struct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
