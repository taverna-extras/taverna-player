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

def format_text_tp_default(content, type)
  content = CodeRay.scan(content, :text).div(:css => :class)
  auto_link(content, :html => { :target => '_blank' }, :sanitize => false)
end

def format_xml_tp_default(content, type)
  out = String.new
  REXML::Document.new(content).write(out, 1)
  CodeRay.scan(out, :xml).div(:css => :class, :line_numbers => :table)
end

def show_image_tp_default(content, type)
  # Can't use image_tag() here because the image doesn't really exist (it's in
  # a zip file, really) and this confuses the Rails asset pipeline.
  tag("img", :src => content)
end

def workflow_error_tp_default(content, type)
  link_to("This output is a workflow error.", content)
end

def cannot_inline_tp_default(content, type)
  "Sorry but we cannot show this type of content in the browser. Please " +
   link_to("download it", content) + " to view it on your local machine."
end

def empty_tp_default(content, type)
  "<div>&lt;empty output&gt;</div>"
end