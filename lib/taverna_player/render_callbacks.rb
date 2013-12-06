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

def format_text_tp_default(output, index = [])
  content = CodeRay.scan(output.value(index), :text).div(:css => :class)
  auto_link(content, :html => { :target => '_blank' }, :sanitize => false)
end

def format_xml_tp_default(output, index = [])
  out = String.new
  REXML::Document.new(output.value(index)).write(out, 1)
  CodeRay.scan(out, :xml).div(:css => :class, :line_numbers => :table)
end

def show_image_tp_default(output, index = [])
  # Can't use image_tag() here because the image doesn't really exist (it's in
  # a zip file, really) and this confuses the Rails asset pipeline.
  tag("img", :src => output.path(index))
end

def workflow_error_tp_default(output, index = [])
  link_to("This output is a workflow error.", output.path(index))
end

def cannot_inline_tp_default(output, index = [])
  "Sorry but we cannot show this type of content in the browser. Please " +
   link_to("download it", output.path(index)) + " to view it on " +
   "your local machine."
end

def empty_tp_default(output, _)
  "<div>&lt;empty output&gt;</div>"
end

def list_tp_default(output, index = [], types = nil)
  types = output.metadata[:type] if types.nil?

  content = "<ol>"
  i = 0
  types.each do |type|
    if type.is_a?(Array)
      content += "<li><br />" +
      list_tp_default(output, index + [i], type) + "</li>"
    else
      content += "<li>(#{type})<p>" +
        TavernaPlayer.output_renderer.render(output, index + [i]) +
        "</p></li>"
    end
    i += 1
  end

  content += "</ol>"
end
