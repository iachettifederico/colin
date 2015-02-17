module Colin
  class Parser
    def initialize(args=[])
      @args = args
      @options = {}
      @skipped = []
      parse
    end

    def options
      @options
    end

    def args
      @skipped
    end

    def inspect
      "<#{self.class} options: #{options.inspect} args: #{args.inspect}>"
    end

    def to_s
      inspect
    end

    def named_options(opts=[])
      opts.each do |opt|
        break if @skipped.empty?
        set(opt.to_s, @skipped.shift)
      end
      self
    end
    
    private

    def parse
      (@args + [nil]).each do |opt|
        case opt
        when /^\w+$/
          if @current
            set(@current, opt)
          else
            skip(opt)
          end
        when /^--([\w-]+)$/
          keep($1)
        when /^--([\w-]+)=([\w\s]+)$/
          consume_current
          set($1, $2)
        when /^-(\w)(\w+)$/
          consume_current
          set($1, $2)
        when /^-(\w)$/
          consume_current
          keep($1)
        when nil
          consume_current
        else
          skip(opt)
        end
      end
    end

    def sanitize(value)
      return true   if value == "true"
      return false  if value == "false"
      return value.to_i if value =~ /^\d+$/
      value
    end

    def set(key, value)
      @options[key.to_sym] = sanitize(value)
      @current = nil if @current
    end

    def keep(opt)
      @current = opt
    end

    def skip(opt)
      @skipped << opt
    end

    def consume_current
      if @current
        if @current =~ /^no-(.+)/
          key   = $1
          value = false
        else
          key   = @current
          value = true
        end
        set(key, value)
      end
    end
  end
end
