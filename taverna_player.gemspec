#------------------------------------------------------------------------------
# Copyright (c) 2013, 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

$:.push File.expand_path("../lib", __FILE__)

require "taverna_player/version"

Gem::Specification.new do |s|
  s.name        = "taverna-player"
  s.version     = TavernaPlayer::VERSION
  s.authors     = ["Robert Haines"]
  s.email       = ["support@mygrid.org.uk"]
  s.homepage    = "http://www.taverna.org.uk"
  s.summary     = "Taverna Player is a rails plugin to run Taverna Workflows."
  s.description = "Taverna Player is a Ruby on Rails plugin to run Taverna "\
    "Workflows using Taverna Server. Taverna Player surfaces a workflow in "\
    "three ways: As a Web interface in the browser; As an embeddable widget "\
    "to be included in any other Web page; As a REST-based Web Service. All "\
    "three modes provide functionality to fully configure a workflow's "\
    "inputs; run the workflow on a Taverna Server; collect workflow outputs, "\
    "logs and messages; and present the results in an appropriate manner."
  s.license     = "BSD"

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- test/*`.split("\n")

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency "jquery-rails", "~> 3.0"
  s.add_dependency "paperclip", "~> 4.1"
  s.add_dependency "t2-server", "~> 1.1"
  s.add_dependency "delayed_job_active_record", "~> 4.0"
  s.add_dependency "daemons", "~> 1.1.9"
  s.add_dependency "rubyzip", "~> 0.9.9"
  s.add_dependency "coderay", "~> 1.1"
  s.add_dependency "rails_autolink", "~> 1.1.0"
  s.add_dependency "require_all", "~> 1.3.1"
  s.add_dependency "pmrpc-rails", "~> 1.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "flexmock", "~> 1.3"

  s.require_path = "lib"
end
