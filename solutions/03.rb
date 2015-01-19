module RBFS
  class File
    attr_accessor :data

    def initialize(data = nil)
      @data = data
    end

    def data_type
      case @data
      when Fixnum, Float         then :number
      when String                then :string
      when Symbol                then :symbol
      when TrueClass, FalseClass then :boolean
      else :nil
      end
    end

    def serialize
      "#{data_type}:#{@data}"
    end

    def self.parse(object)
      type, data = object.split(':', 2)
      data = case type
             when 'string'  then data
             when 'symbol'  then data.to_sym
             when 'number'  then data.to_f
             when 'boolean' then data == 'true'
             else nil
             end
      self.new (data)
    end
  end

  class Directory
    attr_reader :files, :directories

    def initialize
      @files = {}
      @directories = {}
    end

    def add_file(name, file)
      @files[name] = file
    end

    def add_directory(name, directory = Directory.new)
      @directories[name] = directory
    end

    def [](name)
      @directories[name] || @files[name]
    end

    def serialize
      "#{files.size}:" + files.map { |name, file|
      "#{name}:#{file.serialize.length}:#{file.serialize}" }.join +
      "#{directories.size}:" + directories.map {|name, directory|
      "#{name}:#{directory.serialize.length}:#{directory.serialize}"}.join
    end

    def self.parse(string)
      directory = Directory.new
      parser = Parser.new(string)
      parser.parse do |name, data|
        directory.add_file(name, File.parse(data))
      end
      parser.parse do |name, data|
        directory.add_directory(name, Directory.parse(data))
      end
      directory
    end
  end

  class Parser
    def initialize(string)
      @data = string
    end

    def parse
      count, @data = @data.split(":", 2)
      count.to_i.times do
        name, length, left = @data.split(":", 3)
        yield name, left[0...length.to_i]
        @data = left[length.to_i..-1]
      end
    end
  end
end