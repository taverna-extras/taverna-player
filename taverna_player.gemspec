$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "taverna_player/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "taverna-player"
  s.version     = TavernaPlayer::VERSION
  s.authors     = ["Robert Haines"]
  s.email       = ["support@mygrid.org.uk"]
  s.homepage    = "http://www.taverna.org.uk"
  s.summary     = "Taverna Player is a rails plugin to run Taverna Workflows."
  s.description = "Taverna Player runs Taverna Workflows using Taverna Server."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENCE.rdoc", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
