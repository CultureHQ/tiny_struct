require 'test_helper'

class TinyStructTest < Minitest::Test
  class Foo < TinyStruct.new(:foo)
    def decorated
      "~~~ #{foo} ~~~"
    end
  end

  def test_version
    refute_nil ::TinyStruct::VERSION
  end

  def test_basic
    assert_equal '~~~ foo ~~~', Foo.new('foo').decorated
  end

  def test_argument_number_parsing
    assert_raises(ArgumentError) { Foo.new }
  end

  def test_parsing_attribute_names
    assert_raises(ArgumentError) { TinyStruct.new(:Foo, :Bar) }
  end

  def test_equality
    assert_equal Foo.new('foo'), Foo.new('foo')
  end

  def test_inspect
    assert_equal "#<TinyStructTest::Foo @foo=\"foo\">", Foo.new('foo').inspect
  end

  def test_inspect_anonymous
    bar = TinyStruct.new(:bar)
    assert_equal "#<TinyStruct @bar=\"bar\">", bar.new('bar').inspect
  end

  def test_defines_only_one_superclass_per_combination
    size = lambda {
      ObjectSpace.each_object(TinyStruct.singleton_class).to_a.size
    }

    starting = size.call
    TinyStruct.new(:foo)
    assert_equal starting, size.call
  end
end
