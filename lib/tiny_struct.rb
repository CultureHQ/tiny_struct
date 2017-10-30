require 'tiny_struct/version'

class TinyStruct
  ATTRIBUTE_PATTERN = /\A[a-z][a-zA-Z0-9_]*\z/

  def eql?(other)
    attributes.zip(other.attributes).all? { |a, b| a == b }
  end
  alias == eql?

  def inspect
    pairs = attributes.map { |name| "@#{name}=#{public_send(name).inspect}" }
    "#<#{self.class.name || 'TinyStruct'} #{pairs.join(' ')}>"
  end
  alias to_s inspect

  def self.attributes
    []
  end

  class << self
    def new(*attributes)
      success =
        attributes.all? do |attribute|
          attribute.is_a?(Symbol) && attribute.match?(ATTRIBUTE_PATTERN)
        end

      if !success
        raise ArgumentError, 'arguments to TinyStruct::new must be valid ' \
                             'attribute names represented as symbols'
      end

      find_class(attributes) || define_class(attributes)
    end

    private

    def define_class(attributes)
      Class.new(TinyStruct) do
        attr_reader(*attributes)

        define_singleton_method(:new, Object.method(:new))
        define_singleton_method(:attributes) { attributes }

        define_method(:initialize) do |*arguments|
          if attributes.size != arguments.size
            message = "wrong number of arguments (given #{arguments.size}, " \
                      "expected #{attributes.size})"
            raise ArgumentError, message
          end

          attributes.zip(arguments).each do |name, value|
            instance_variable_set(:"@#{name}", value)
          end
        end

        define_method(:attributes) { attributes }
        protected :attributes
      end
    end

    def find_class(attributes)
      ObjectSpace.each_object(TinyStruct.singleton_class).detect do |clazz|
        clazz.attributes == attributes
      end
    end
  end
end
