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

module TavernaPlayer
  class Interaction < ActiveRecord::Base
    attr_accessible :displayed, :feed_reply, :page, :replied

    belongs_to :run, :class_name => "TavernaPlayer::Run",
      :inverse_of => :interactions

    validates_presence_of :serial
    validates_uniqueness_of :serial, :scope => :run_id,
      :message => "Interaction serial number should be unique for a run"
  end
end
