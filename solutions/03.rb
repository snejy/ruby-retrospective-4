module RBFS
  class File
    attr_reader :data_type
    attr_accessor :data

    def initialize(data = nil)
        @data = data
        @data_type = get_data_type
    end

    def get_data_type
      case @data
      when Numeric then :number
      when String then :string
      when Symbol then :symbol
      when !!@data then :boolean
      else :nil
      end
    end

    def self.to_num(string_number)
      if string_number.include? '.'
      then string_number.to_f
      else string_number.to_i
      end
    end

    def self.to_bool(string_boolean)
      string_boolean == 'true'
    end

    def self.data_from_type(string_data_type, string_data)
      case string_data
      when "number" then self.to_num(string_data)
      when "symbol" then string_data.to_sym
      when "boolean" then self.to_bool(string_data_type)
      when "nil" then nil
      else string_data
      end
    end

    def serialize
      @data_type = get_data_type
      "#{@data_type}:#{@data}"
    end

    def self.parse(object)
      type, data = object.split(':')
      self.new (self.data_from_type(data, type))
    end
  end

  class Directory
    attr_reader :files

    def initialize
      @hierarchy = {}
    end

    def files
      @hierarchy.select { |key, value| value.instance_of? RBFS::File }
    end

    def directories
       @hierarchy.select { |key, value| value.instance_of? RBFS::Directory }
    end

    def add_file(name, file)
      @hierarchy[name] = file unless name.include? ":"
    end

    def add_directory(name, direcotry = RBFS::Directory.new)
      @hierarchy[name] = direcotry unless name.include? ":"
    end

    def [](name)
      @hierarchy[name]
    end

    def serialize
      "#{self.files.size}:" + self.files.map { |name, file|
      "#{name}:#{file.serialize.length}:#{file.serialize}" }.join +
      "#{self.directories.size}:" + self.directories.map {|name, dir|
      "#{name}:#{dir.serialize.length}:#{dir.serialize}"}.join
    end

    def self.parse(object)
    end
  end
end