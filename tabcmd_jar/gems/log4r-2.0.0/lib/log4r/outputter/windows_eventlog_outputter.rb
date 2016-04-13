#
#
# Author:: Dav Lion

begin
require 'win32/eventlog'

module Log4r

  class WindowsEventlogOutputter < Outputter

    #from the windows-pr-1.0.1 gem
    EVENTLOG_SUCCESS          = 0x0000
    EVENTLOG_ERROR_TYPE       = 0x0001
    EVENTLOG_WARNING_TYPE     = 0x0002
    EVENTLOG_INFORMATION_TYPE = 0x0004
    EVENTLOG_AUDIT_SUCCESS    = 0x0008
    EVENTLOG_AUDIT_FAILURE    = 0x0010

    # There are 3 hash arguments
    #
    # [<tt>:ident</tt>]     syslog ident, defaults to _name
    def initialize(_name, hash={})
      super(_name, hash)
      hash[:server_name] ||= nil
      hash[:source_name] ||= 'Application'
      ident = (hash[:ident] or _name)
      @eventlog = EventLog.openEventLog(hash[:server_name], hash[:source_name])
      @source = EventLog.registerEventSource(hash[:server_name], hash[:source_name])
    end

    def closed?
      return !@eventlog.nil?
    end

    def close
      result = EventLog.deregisterEventSource(@source)
      if (result)
        @source = nil
        result = EventLog.closeEventLog(@eventlog)
        if (result)
          @eventlog = nil
        else
          Logger.log_internal {"Outputter '#{@name}' unable to closeEventLog"}
        end
      else
          Logger.log_internal {"Outputter '#{@name}' unable to deregisterEventSource"}
      end

      @level = OFF
      OutputterFactory.create_methods(self)
      Logger.log_internal {"Outputter '#{@name}' closed Windows Event Log and set to OFF"}
    end

    private

    ## DEBUG,PROFILE,NOTICE,INFO,WARN,ERROR,FATAL
    def map_logging_level(level)
      if level < 5
        return EVENTLOG_INFORMATION_TYPE
      elsif level < 6
        return EVENTLOG_WARNING_TYPE
      else
        return EVENTLOG_ERROR_TYPE
      end
    end

    def canonical_log(logevent)
      return unless @eventlog && @source
      o = logevent.data
      msg = format(logevent)
      data = [msg].pack('P*')
      raw_data = ""
      user_sid = nil

      type_id = nil # need to reconcile with levels somehow
      type_id = map_logging_level(logevent.level)

      event_id = 0x1000 # $NOTE-thanson-2009-04-17 changed to match log4j. 
      category_id = 0 # will show as "None" in the logs

      result = EventLog.reportEvent(@source, type_id, category_id, event_id, user_sid, 1, 0, data, raw_data)
      unless result
        Logger.log_internal {"Outputter '#{@name}' unable to reportEvent"}
      end
    end
  end
end

rescue Exception => detail
  module Log4r
    class WindowsEventlogOutputter < Outputter
      def initialize(_name, hash={})
        super(_name, hash)
      end

      def closed?
        @level == OFF
      end

      def close
        @level = OFF
        OutputterFactory.create_methods(self)
      end
    end
  end
end
