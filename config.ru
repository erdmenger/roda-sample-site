# The top level 'Configuration' file of the website
# required by Rack, so that 'bundle exec rackup' actualy
# actually loads the application after start of the server

require File.expand_path("../webapp", __FILE__)
run Webapp.app

