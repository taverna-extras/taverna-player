require "zip/zip"

module TavernaPlayer
  module RunsHelper

    def show_output(output)
      if output.depth == 0
        if output.file.blank?
          simple_format(output.value)
        else
          case output.metadata[:type]
          when /text/
            File.open(output.file.path) do |file|
              simple_format(file.read)
            end
          when /image/
            image_tag(output.file.url)
          else
            link_to(output.file.url)
          end
        end
      else
        simple_format(parse_port_list(output))
      end
    end

    private

    def parse_port_list(output)
      types = output.metadata[:type]
      content = ""

      Zip::ZipFile.open(output.file.path) do |zip|
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
            zip_path = (index + [i]).map { |i| i += 1 }.join("/")
            content += zip.read(zip_path)
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

      content += "</ul>"
      content
    end

  end
end
