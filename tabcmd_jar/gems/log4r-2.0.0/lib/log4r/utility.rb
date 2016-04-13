module Log4r

  # See log4r/configurator.rb
  module Utility

    def initialize_logging_context(reload=true)
      if (reload)
        set_localip_localhostname
      end
      Log4r::Logger::NDC.set(:local_ip, $local_ip)
      Log4r::Logger::NDC.set(:local_hostname, $local_hostname)
      Log4r::Logger::NDC.set(:process_pid, Process.pid)
      Log4r::Logger::NDC.set(:thread_id, Thread.current.inspect[2..-1].split(' ')[0].gsub('Thread:',''))
    end

    def set_localip_localhostname
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
      $local_hostname = Socket.gethostname()
      UDPSocket.open do |s|
        s.connect($local_hostname,1)
        $local_ip = s.addr.last
      end
      Socket.do_not_reverse_lookup = orig
    end
  end
end
