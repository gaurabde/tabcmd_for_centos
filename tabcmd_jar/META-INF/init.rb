WARBLER_CONFIG = {}

ENV['GEM_HOME'] ||= File.expand_path('../..', __FILE__)

$LOAD_PATH.unshift __FILE__.sub(/!.*/, '!/tabcmd/lib')
require 'rubygems'
ENV['BUNDLE_WITHOUT'] = 'development:test'
ENV['BUNDLE_GEMFILE'] = 'Gemfile'

