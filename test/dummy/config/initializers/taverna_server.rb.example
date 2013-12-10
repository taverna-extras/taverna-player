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

# Taverna Player Server configuration

TavernaPlayer.setup do |config|

  # Taverna Server configuration information. The poll interval is in seconds.
  config.server_address = "https://example.com:8443/tavserv"
  config.server_username = "taverna"
  config.server_password = "taverna"
  config.server_poll_interval = 1
  config.server_retry_interval = 10

  # Taverna Server connection configuration.
  config.server_connection[:open_timeout] = 10
end
