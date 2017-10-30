class TinyStruct
  # Maintains an in-memory cache of the defined `TinyStruct` classes, such that
  # classes with the same attribute list do not end up getting created twice.
  #
  # This cache makes performance quite a bit better since looping through
  # `ObjectSpace` takes a while, but takes a hit on memory because everything
  # is now stored. Also prevents the classes from being freed if they were
  # created anonymously and could have otherwise have been freed.
  class MemoryCache
    attr_reader :cache

    def initialize
      @cache = {}
    end

    def []=(members, clazz)
      cache[members] = clazz
    end

    def [](members)
      cache[members]
    end
  end
end
