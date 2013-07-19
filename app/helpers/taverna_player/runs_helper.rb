module TavernaPlayer
  module RunsHelper

    def show_output(run, output)
      if output.depth == 0
        if output.value.blank?
          full_path = run_path(output.run_id) + "/output/#{output.name}"

          case output.metadata[:type]
          when /x-error/
            link_to("Error", full_path)
          when /image/
            image_tag(full_path)
          else
            link_to(full_path)
          end
        else
          if output.metadata[:size] < 255
            format_text_output(output.value, output.metadata[:type])
          else
            Zip::ZipFile.open(run.results.path) do |zip|
              format_text_output(zip.read(output.name), output.metadata[:type])
            end
          end
        end
      else
        parse_port_list(run, output)
      end
    end

    private

    def format_text_output(content, type)
      type = type.gsub(/.+\/(.+)/) do
        %w(html xml json).include?($1) ? $1 : "text"
      end.to_sym

      if type == :text
        raw(CodeRay.scan(content, type).div(:css => :class))
      else
        content = format_xml(content) if type == :xml
        raw(CodeRay.scan(content, type).div(:css => :class,
          :line_numbers => :table))
      end
    end

    def format_xml(xml)
      out = String.new
      REXML::Document.new(xml).write(out, 1)
      out
    end

    def parse_port_list(run, output)
      types = output.metadata[:type]
      content = String.new

      Zip::ZipFile.open(run.results.path) do |zip|
        content = deep_parse(types, output, zip)
      end

      content
    end

    def deep_parse(types, output, zip, index = [])
      content = "<ul>"
      i = 0
      types.each do |type|
        if type.is_a?(Array)
          content += "<li>List #{i}" +
            deep_parse(type, output, zip, index + [i]) + "</li>"
        else
          path = (index + [i]).join("/")
          content += "<li>"
          case type
          when /x-error/
            content += link_to("Error", run_path(output.run_id) +
              "/output/#{output.name}/#{path}")
          when /text/
            zip_path = (index + [i]).map { |j| j += 1 }.join("/")
            content += format_text_output(
              zip.read("#{output.name}/#{zip_path}"), type)
          when /image/
            content += image_tag(run_path(output.run_id) +
              "/output/#{output.name}/#{path}")
          else
           content += link_to(index, run_path(output.run_id) +
            "/output/#{output.name}/#{path}")
          end
          content += "</li>"
        end
        i += 1
      end

      raw(content += "</ul>")
    end

  end
end
