module UI
  class Style
    def initialize
      @labels = []
      @horizontal = []
    end

    def form(text, border)
      border + text + border
    end

    def style(text, style)
      style.length != 0 ? text.send(style) : text
    end

    def label(arguments_to_style)
      @style, @border = arguments_to_style[:style], arguments_to_style[:border]
      @labels << style(arguments_to_style[:text], @style.to_s)
      @labels.map { |word| form(word, @border.to_s) }
    end

    def vertical(text, options)
      @border, @style = options[:border].to_s, options[:style].to_s
      max = text.max_by(&:length).length
      text.map { |ch| form(style(ch.ljust(max), @style), @border) + "\n" }.join
    end

    def horizontal(text, options)
      @border, @style, @labels = options[:border], options[:style], []
      horizontal = []
        text.each do |word|
          horizontal << style(word, @style.to_s)
        end
      @horizontal << form(horizontal.join, @border.to_s)
    end
  end

  class TextScreen
    def self.draw(&block)
      @blocks_count = 1
      @style = Style.new()
      instance_eval(&block)
    end

    def self.label(label)
      @blocks_count == 1 ? @style.label(label).join : @style.label(label)
    end

    def self.vertical(options = {}, &block)
      @blocks_count += 1
      @style.vertical(instance_eval(&block), options)
    end

    def self.horizontal(options = {}, &block)
      @blocks_count += 1
      @style.horizontal(instance_exec(&block), options)
    end
  end
end