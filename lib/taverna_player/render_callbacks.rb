
def format_text(content, type)
  content = CodeRay.scan(content, :text).div(:css => :class)
  raw(auto_link(content, :html => { :target => '_blank' }, :sanitize => false))
end

def format_xml(content, type)
  out = String.new
  REXML::Document.new(content).write(out, 1)
  raw(CodeRay.scan(out, :xml).div(:css => :class, :line_numbers => :table))
end

def show_image(content, type)
  # Can't use image_tag() here because the image doesn't really exist (it's in
  # a zip file, really) and this confuses the Rails asset pipeline.
  tag("img", :src => content)
end

def workflow_error(content, type)
  link_to("This output is a workflow error.", content)
end

def cannot_inline(content, type)
  "Sorry but we cannot show this type of content in the browser. Please " +
   link_to("download it", content) + " to view it on your local machine."
end
