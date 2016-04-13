
# :nodoc:
# Version:: $Id: rollingfileoutputter.rb,v 1.4 2003/09/12 23:55:43 fando Exp $

require "log4r/outputter/fileoutputter"
require "log4r/staticlogger"

module Log4r

  # RollingFileOutputter - subclass of FileOutputter that rolls files on size
  # or time. Additional hash arguments are:
  #
  # [<tt>:maxsize</tt>]   Maximum size of the file in bytes.
  # [<tt>:maxtime</tt>]	  Maximum age of the file in seconds.
  class RollingFileOutputter < FileOutputter

    attr_reader :count, :maxsize, :maxtime, :startTime

    def initialize(_name, hash={})
      @maxsize = 0
      @maxtime = 0
      @datasize = 0

      set_maxsize(hash)
      set_maxtime(hash)

      if @maxtime > 0 || @maxsize > 0
        @filebase = hash[:filename] or hash['filename'] or "file.log"
        makeNewFilename
        hash[:filename] = hash['filename'] = @filename
      end

      super(_name, hash)

      roll if file_size_requires_roll?
    end

    #######
    private
    #######
    
    def makeNewFilename
      if @maxtime > 0 || @maxsize > 0
        timestamp = Time.now.strftime("%Y_%m_%d_%H_%M_%S")

        @filename = @filebase.sub(/(\.\w*)$/, "_#{timestamp}" + '\1')
      end
    end

    def set_maxtime(hash)
      if hash.has_key?(:maxtime) || hash.has_key?('maxtime') 
        @maxtime = (hash[:maxtime] or hash['maxtime']).to_i
        @startTime = Time.now
      end
    end

    def set_maxsize(options) 
      if options.has_key?(:maxsize) || options.has_key?('maxsize')
        maxsize = (options[:maxsize] or options['maxsize'])

        multiplier = 1
        if (maxsize =~ /\d+KB/)
          multiplier = 1024
        elsif (maxsize =~ /\d+MB/)
          multiplier = 1024 * 1024
        elsif (maxsize =~ /\d+GB/)
          multiplier = 1024 * 1024 * 1024
        end
        
        _maxsize = maxsize.to_i * multiplier
        
        if _maxsize.class != Fixnum and _maxsize.class != Bignum
          raise TypeError, "Argument 'maxsize' must be an Fixnum", caller
        end
        @maxsize = _maxsize
      end
    end

    # perform the write
    def write(data) 
      # we have to keep track of the file size ourselves - File.size doesn't
      # seem to report the correct size when the size changes rapidly
      @datasize += data.size + 1 if @maxsize > 0 # the 1 is for newline
      roll if requiresRoll?
      super
    end

    # does the file require a roll?
    def requiresRoll?
      if @maxsize > 0 && @datasize > @maxsize
        @datasize = 0
        return true
      end
      if @maxtime > 0 && (Time.now - @startTime) > @maxtime
        @startTime = Time.now
        return true
      end
      false
    end 
    
    # more expensive, only for startup
    def file_size_requires_roll?
      (@maxsize.to_i > 0 and (File.size?(@filename).to_i >= @maxsize.to_i))
    end
    
    # roll the file
    def roll
      begin
        @out.close
      rescue 
        Logger.log_internal {
          "RollingFileOutputter '#{@name}' could not close #{@filename}"
        }
      end

      makeNewFilename

      @out = File.new(@filename, (@trunc ? "w" : "a"))
      Logger.log_internal {
        "RollingFileOutputter '#{@name}' now writing to #{@filename}"
      }
    end 

  end

end

# this can be found in examples/fileroll.rb as well
if __FILE__ == $0
  require 'log4r'
  include Log4r


  timeLog = Logger.new 'WbExplorer'
  timeLog.outputters = RollingFileOutputter.new("WbExplorer", { "filename" => "TestTime.log", "maxtime" => 10, "trunc" => true })
  timeLog.level = DEBUG

  100.times { |t|
    timeLog.info "blah #{t}"
    sleep(1.0)
  }

  sizeLog = Logger.new 'WbExplorer'
  sizeLog.outputters = RollingFileOutputter.new("WbExplorer", { "filename" => "TestSize.log", "maxsize" => 16000, "trunc" => true })
  sizeLog.level = DEBUG

  10000.times { |t|
    sizeLog.info "blah #{t}"
  }

end
