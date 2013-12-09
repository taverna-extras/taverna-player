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

# These methods are the default renderer callbacks that Taverna Player uses.
# If you customize (or add to) the methods in this file you must register them
# in the Taverna Player initializer. These methods will not override the
# defaults automatically.
#
# Each method MUST accept two parameters:
#  * The first (port) is the port to be rendered.
#  * The second (index) is the index into the port. For singleton ports this
#    will be the empty list.
#
# Note that you can use most of the ActiveView Helpers here as global methods
# but the image_tag() method does not work as explained below.

def format_text(port, index = [])
  # Use CodeRay to format text so that newlines are respected.
  content = CodeRay.scan(port.value(index), :text).div(:css => :class)

  # Use auto_link to turn URI-like text into links.
  auto_link(content, :html => { :target => '_blank' }, :sanitize => false)
end

def format_xml(port, index = [])
  # Make sure XML is indented consistently.
  out = String.new
  REXML::Document.new(port.value(index)).write(out, 1)
  CodeRay.scan(out, :xml).div(:css => :class, :line_numbers => :table)
end

def show_image(port, index = [])
  # Can't use image_tag() here because the image doesn't really exist (it's in
  # a zip file, really) and this confuses the Rails asset pipeline.
  tag("img", :src => port.path(index))
end

def workflow_error(port, index = [])
  link_to("This output is a workflow error.", port.path(index))
end

def cannot_inline(port, index = [])
  "Sorry but we cannot show this type of content in the browser. Please " +
   link_to("download it", port.path(index)) + " to view it on " +
   "your local machine."
end

# Rendering an empty port has no need of the index parameter.
def empty_port(port, _)
  "<div>&lt;empty port&gt;</div>"
end

# Rendering a list port requires recursion. In this implementation an extra
# parameter (types) is added to drive the recursion; we can't just keep track
# of depth because we need to know the length of each sub-list - and types can
# be used to pass that through for us.
def list_port(port, index = [], types = nil)
  types = port.metadata[:type] if types.nil?

  content = "<ol>"
  i = 0
  types.each do |type|
    if type.is_a?(Array)
      content += "<li><br />" +
      list_port(port, index + [i], type) + "</li>"
    else
      content += "<li>(#{type})<p>" +
        TavernaPlayer.port_renderer.render(port, index + [i]) +
        "</p></li>"
    end
    i += 1
  end

  content += "</ol>"
end
