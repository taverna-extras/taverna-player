#!/usr/bin/env rake
#------------------------------------------------------------------------------
# Copyright (c) 2013 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.main     = 'README.rdoc'
  rdoc.title    = 'Taverna Player'
  rdoc.options << '--line-numbers'
  rdoc.options << "--tab-width=2"

  files = [
    "CHANGES.rdoc",
    "README.rdoc",
    "LICENCE.rdoc",
    "app/helpers/taverna_player/application_helper.rb",
    "app/models/taverna_player/run.rb",
    "app/models/taverna_player/run_port.rb",
    "app/models/taverna_player/service_credential.rb",
    "lib/taverna-player.rb",
    "lib/taverna_player/port_renderer.rb"
    ]

  rdoc.rdoc_files.include(files)
end

APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'



Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

Rake::TestTask.new(:"test:worker") do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = ["test/integration/test_worker.rb"]
  t.verbose = false
end

task :default => :test
