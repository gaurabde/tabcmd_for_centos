# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby-debug-base"
  s.version = "0.10.4"
  s.platform = "java"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["debug-commons team"]
  s.date = "2010-11-09"
  s.description = "Java extension to make fast ruby debugger run on JRuby.\nIt is the same what ruby-debug-base is for native Ruby.\n"
  s.files = ["AUTHORS", "ChangeLog", "lib/linecache.rb", "lib/linecache-ruby.rb", "lib/ruby-debug-base.rb", "lib/ruby_debug.jar", "lib/tracelines.rb", "MIT-LICENSE", "Rakefile", "README"]
  s.homepage = "http://rubyforge.org/projects/debug-commons/"
  s.require_paths = ["lib"]
  s.rubyforge_project = "debug-commons"
  s.rubygems_version = "1.8.15"
  s.summary = "Java implementation of Fast Ruby Debugger"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
