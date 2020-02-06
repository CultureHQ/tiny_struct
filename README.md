# TinyStruct

[![Build Status](https://github.com/CultureHQ/tiny_struct/workflows/Main/badge.svg)](https://github.com/CultureHQ/tiny_struct/actions)
[![Gem Version](https://img.shields.io/gem/v/tiny_struct.svg)](https://github.com/CultureHQ/tiny_struct)

Often we want simple Ruby classes that follow the pattern of accepting data as arguments to the initializer and storing them as `attr_readers`. For example:

```ruby
class User
  attr_reader :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def to_s
    "#{name} <#{email}>"
  end
end

user = User.new('Harry Potter', 'hpotter@hogwarts.edu')
# => #<User @name="Harry Potter" @email="hpotter@hogwarts.edu">
```

This is pretty common, and more or less resembles a struct and an associated initializer in many other languages (see initializer lists in C++ or case classes in Scala).

You could refactor the above to inherit from Ruby's own `Struct` class, as in:

```ruby
class User < Struct.new(:name, :email)
  def to_s
    "#{name} <#{email}>"
  end
end
```

This totally works! `Struct::new` returns a class, from which `User` then inherits. This pattern is great because it encapsulates the initialization and enforces a certain consistency over the way objects are created within a codebase.

However, there is a certain amount of bloat that comes from using the `Struct` class. Ruby defines a number of enumerable and comparison methods to allow them to function more like structs in other languages. This is why we built `TinyStruct`, which is effectively the same thing as a `Struct` but it does much less:

* In `Struct` classes all parameters are optional, in `TinyStruct` they are all required (encouraging explicit values for each member).
* In `Struct` classes each parameter is accessible through an `attr_accessor`, in `TinyStruct` they are accessible through `attr_reader`s (encouraging more data encapsulation).
* In `Struct` classes you can call all kinds of querying methods on the objects as if they were an enumerable of the various values they represent (e.g., `to_a`, `to_h`, `size`, `[]`, `values_at`, etc.), in `TinyStruct` none of these methods are defined (minifying the surface area of the class to encourage explicit method definitions if necessary).

You can use `TinyStruct` in the exact same way that you could use `Struct` (by inheriting from an object returned by the `::new` method.

Use `Struct` if you need the flexibility and extra query methods provided by the constructor. If not, consider using `TinyStruct`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tiny_struct'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tiny_struct

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CultureHQ/tiny_struct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
