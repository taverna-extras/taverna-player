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

  # This class manages the rendering of many different output types that could
  # be produced by a workflow. It can be configured with new types and the
  # example renderers for each type can also be changed. An example of how to
  # set it up can be found in the taverna_player initializer.
  #
  # Each renderer has all of the ActionView::Helpers (such as link_to, tag,
  # etc) available to them.
  class OutputRenderer
    include TavernaPlayer::Concerns::Callback

    # The renderers are all called in the scope of this class so we include
    # ActionView::Helpers here so that they are all available to them.
    include ActionView::Helpers

    # :stopdoc:
    # Taverna Workflow error MIME type
    TAVERNA_ERROR_TYPE = MIME::Type.new("application/x-error")

    # Empty file MIME types as used in older and new versions of "file".
    EMPTY_FILE_OLD = MIME::Type.new("application/x-empty")
    EMPTY_FILE_NEW = MIME::Type.new("inode/x-empty")

    def initialize
      @hash = Hash.new
      MIME::Types.add(TAVERNA_ERROR_TYPE, EMPTY_FILE_OLD, EMPTY_FILE_NEW)
    end
    # :startdoc:

    # :call-seq:
    #   add(mimetype, renderer, default = false)
    #
    # Add a renderer method for the specified MIME type. If you would like the
    # renderer to be the default for that particular media type then pass true
    # in the final parameter - the media type is the part of a MIME type before
    # the slash (/), e.g. "text" or "image". The MIME type should be specified
    # as a string.
    def add(mimetype, method, default = false)
      type = MIME::Types[mimetype].first

      @hash[type.media_type] ||= {}
      @hash[type.media_type][type.sub_type] = method
      @hash[type.media_type][:default] = method if default
    end

    # :call-seq:
    #   type_default(media_type, renderer)
    #
    # This is another way of setting the default renderer method for a whole
    # media type (see the add method for more details).
    def type_default(media_type, method)
      @hash[media_type] ||= {}
      @hash[media_type][:default] = method
    end

    # :call-seq:
    #   default(method)
    #
    # Set a default renderer for any MIME type not specifically set. This
    # could be used to supply a piece of text and a download link for any type
    # that cannot normally be shown in the browser inline.
    def default(method)
      @hash[:default] = method
    end

    # :call-seq:
    #   render(content, mimetype) -> markup
    #
    # This is the method that calls the correct renderer for the given content
    # with the given MIME type and returns the resultant rendering.
    def render(content, mimetype)
      type = MIME::Types[mimetype].first

      renderer = @hash[type.media_type][type.sub_type] ||
        @hash[type.media_type][:default] || @hash[:default]

      callback(renderer, content, type)
    end

  end
end
