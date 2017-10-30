class TinyStruct
  # Allows for finding previously constructed `TinyStruct` classes that contain
  # a certain set of members so that they do not end up getting created twice.
  #
  # This cache saves some on space because we're not storing them in memory,
  # but takes a slight hit to performance whenever a new class in defined.
  class ObjectSpaceCache
    def []=(*); end

    def [](members)
      ObjectSpace.each_object(TinyStruct.singleton_class).detect do |clazz|
        clazz != TinyStruct && clazz.members == members
      end
    end
  end
end
