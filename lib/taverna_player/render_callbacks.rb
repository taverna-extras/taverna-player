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

def format_text_tp_default(port, index = [])
  content = CodeRay.scan(port.value(index), :text).div(:css => :class)
  auto_link(content, :html => { :target => '_blank' }, :sanitize => false)
end

def format_xml_tp_default(port, index = [])
  out = String.new
  REXML::Document.new(port.value(index)).write(out, 1)
  CodeRay.scan(out, :xml).div(:css => :class, :line_numbers => :table)
end

def show_image_tp_default(port, index = [])
  # Can't use image_tag() here because the image doesn't really exist (it's in
  # a zip file, really) and this confuses the Rails asset pipeline.
  tag("img", :src => port.path(index))
end

def workflow_error_tp_default(port, index = [])
  link_to("This output is a workflow error.", port.path(index))
end

def cannot_inline_tp_default(port, index = [])
  "Sorry but we cannot show this type of content in the browser. Please " +
   link_to("download it", port.path(index)) + " to view it on " +
   "your local machine."
end

def empty_tp_default(port, _)
  "<div>&lt;empty port&gt;</div>"
end

def list_tp_default(port, index = [], types = nil)
  types = port.metadata[:type] if types.nil?

  content = "<ol>"
  i = 0
  types.each do |type|
    if type.is_a?(Array)
      content += "<li><br />" +
      list_tp_default(port, index + [i], type) + "</li>"
    else
      content += "<li>(#{type})<p>" +
        TavernaPlayer.port_renderer.render(port, index + [i]) +
        "</p></li>"
    end
    i += 1
  end

  content += "</ol>"
end
