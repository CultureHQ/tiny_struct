require 'tiny_struct/version'

# A class for encompassing the simple pattern of required and ordered parameters
# and their associated reader methods. To create a new class, run:
#
#     class User < TinyStruct.new(:first_name, :last_name)
#       def full_name
#         "#{first_name} #{last_name}"
#       end
#     end
#
# This will create a class that now has `attr_reader`s for `first_name` and
# `last_name`, as well as having an initializer that sets those values.
class TinyStruct
  ATTRIBUTE_PATTERN = /\A[a-z][a-zA-Z0-9_]*\z/.freeze

  # `true` if the members of the other `TinyStruct` instance are equal to
  # the values of this `TinyStruct` instance.
  def eql?(other)
    other.class.respond_to?(:members) &&
      self.class.members == other.class.members &&
      self.class.members.all? do |attribute|
        public_send(attribute) == other.public_send(attribute)
      end
  end
  alias == eql?

  def inspect
    pairs =
      self.class.members.map { |name| "@#{name}=#{public_send(name).inspect}" }
    "#<#{self.class.name || 'TinyStruct'} #{pairs.join(' ')}>"
  end
  alias to_s inspect

  class << self
    # Builds a new `TinyStruct` subclass based on the given members. The
    # given members must be symbols that represents names that could
    # otherwise be used as argument names.
    def new(*members)
      success =
        members.all? do |attribute|
          attribute.is_a?(Symbol) && attribute.match?(ATTRIBUTE_PATTERN)
        end

      unless success
        raise ArgumentError, 'arguments to TinyStruct::new must be valid ' \
                             'attribute names represented as symbols'
      end

      class_cache[members] ||= define_class(members)
    end

    private

    def define_class(members)
      clazz =
        Class.new(TinyStruct) do
          attr_reader(*members)
          define_singleton_method(:new, Object.method(:new))
          define_singleton_method(:members) { members }
        end

      define_initialize_method(clazz, members)
      clazz
    end

    def define_initialize_method(clazz, members)
      clazz.send(:define_method, :initialize) do |*arguments|
        if members.size != arguments.size
          message = "wrong number of arguments (given #{arguments.size}, " \
                    "expected #{members.size})"
          raise ArgumentError, message
        end

        members.zip(arguments).each do |name, value|
          instance_variable_set(:"@#{name}", value)
        end
      end
    end

    def class_cache
      @class_cache ||= {}
    end
  end
end
