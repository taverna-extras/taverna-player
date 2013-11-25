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

namespace :taverna_player do
  desc "Delete all completed embedded workflow runs."
  task :delete_completed_embedded_runs => :environment do

    gone = 0
    TavernaPlayer::Run.find_all_by_embedded(true).each do |run|
      if run.complete?
        gone += 1 if run.destroy
      end
    end

    puts "#{gone} complete embedded runs were deleted."
  end
end
