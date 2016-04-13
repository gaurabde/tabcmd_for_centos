# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "log4r"
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Revolution Health"]
  s.autorequire = "log4r"
  s.date = "2009-02-05"
  s.description = "Updated version of Log4r"
  s.email = "rails-trunk@revolutionhealth.com"
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "log4r_original_LICENSE", "lib/log4r", "lib/log4r/base.rb", "lib/log4r/config.rb", "lib/log4r/configurator.rb", "lib/log4r/formatter", "lib/log4r/formatter/formatter.rb", "lib/log4r/formatter/patternformatter.rb", "lib/log4r/lib", "lib/log4r/lib/drbloader.rb", "lib/log4r/lib/xmlloader.rb", "lib/log4r/logevent.rb", "lib/log4r/logger.rb", "lib/log4r/loggerfactory.rb", "lib/log4r/logserver.rb", "lib/log4r/outputter", "lib/log4r/outputter/consoleoutputters.rb", "lib/log4r/outputter/datefileoutputter.rb", "lib/log4r/outputter/emailoutputter.rb", "lib/log4r/outputter/fileoutputter.rb", "lib/log4r/outputter/iooutputter.rb", "lib/log4r/outputter/outputter.rb", "lib/log4r/outputter/outputterfactory.rb", "lib/log4r/outputter/remoteoutputter.rb", "lib/log4r/outputter/rollingfileoutputter.rb", "lib/log4r/outputter/staticoutputter.rb", "lib/log4r/outputter/syslogoutputter.rb", "lib/log4r/repository.rb", "lib/log4r/staticlogger.rb", "lib/log4r/yamlconfigurator.rb", "lib/log4r.rb", "lib/log4r_logging.rb", "lib/rails_patch_for_migrations.rb", "lib/test", "lib/test/log_sql_per_test.rb", "test/log4r_test.rb", "test/orig_tests", "test/orig_tests/include.rb", "test/orig_tests/runtest.rb", "test/orig_tests/testbase.rb", "test/orig_tests/testcustom.rb", "test/orig_tests/testdefault.rb", "test/orig_tests/testformatter.rb", "test/orig_tests/testlogger.rb", "test/orig_tests/testoutputter.rb", "test/orig_tests/testpatternformatter.rb", "test/orig_tests/testxmlconf.rb", "test/orig_tests/xml", "test/orig_tests/xml/testconf.xml", "test/test_helper.rb", "config/log4r.xml"]
  s.homepage = "http://github.com/revolutionhealth/log4r/tree/master"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "Updated version of Log4r"

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
