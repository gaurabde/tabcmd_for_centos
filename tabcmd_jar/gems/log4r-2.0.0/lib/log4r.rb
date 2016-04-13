# :include: log4r/rdoc/log4r
#
# == Other Info
#
# Author::      Leon Torres
# Version::     $Id: log4r.rb,v 1.10 2002/08/20 04:15:04 cepheus Exp $

require 'log4r/configurator'
require 'log4r/formatter/formatter'
require "log4r/formatter/patternformatter"
require "log4r/outputter/fileoutputter"
require "log4r/outputter/consoleoutputters"
require "log4r/outputter/staticoutputter"
require "log4r/outputter/rollingfileoutputter"
require "log4r/outputter/syslogoutputter"
require "log4r/outputter/windows_eventlog_outputter"
require "log4r/loggerfactory"
require "test/log_sql_per_test.rb"
require "log4r/utility"

module Log4r
  Log4rVersion = [2, 0, 0].join '.'
#  ZAPHOD_PATTERN = '<%=%(%d#%l#server=#{local_ip}:#{local_hostname}#service=%g%z#pid=#{Process.pid}#wid=#{AppConfig.worker_id}#tid=#%y %m)%>'
  ZAPHOD_PATTERN = %(%d#%l#server=%x{:local_ip}:%x{:local_hostname}#service=%g%x{:session_id}#pid=%x{:process_pid}#wid=%x{:worker_id}#tid=#%y %m)
end

## Tableau builds our logger programmatically elsewhere....
# if defined?(Rails)
#   if Rails::VERSION::MAJOR < 2
#     require 'rails_patch_for_migrations'
#   end

#   require 'log4r_logging'
# end
