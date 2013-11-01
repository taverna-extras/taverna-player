module TavernaPlayer
  module RunsHelper

    def interaction_redirect(interaction)
      if interaction.page_uri.blank?
        run_url(interaction.run) + "/proxy/#{interaction.unique_id}/page.html"
      else
        interaction.page_uri
      end
    end

    def show_output(run, output)
      if output.depth == 0
        if output.value.blank?
          content = run_path(output.run_id) + "/output/#{output.name}"
        else
          if output.metadata[:size] < 255
            content = output.value
          else
            Zip::ZipFile.open(run.results.path) do |zip|
              content = zip.read(output.name)
            end
          end
        end
        raw(TavernaPlayer.output_renderer.render(content, output.metadata[:type]))
      else
        parse_port_list(run, output)
      end
    end

    private

    def parse_port_list(run, output)
      types = output.metadata[:type]
      content = String.new

      Zip::ZipFile.open(run.results.path) do |zip|
        content = deep_parse(types, output, zip)
      end

      content
    end

    def deep_parse(types, output, zip, index = [])
      content = "<ol>"
      i = 0
      types.each do |type|
        if type.is_a?(Array)
          content += "<li><br />" +
            deep_parse(type, output, zip, index + [i]) + "</li>"
        else
          # Text outputs are inlined here by us. Other types are linked and
          # inlined by the browser.
          content += "<li>(#{type})<p>"
          if type.starts_with?("text")
            path = (index + [i]).map { |j| j += 1 }.join("/")
            data = zip.read("#{output.name}/#{path}")
          else
            path = (index + [i]).join("/")
            data = run_path(output.run_id) + "/output/#{output.name}/#{path}"
          end
          content += TavernaPlayer.output_renderer.render(data, type)
          content += "</p></li>"
        end
        i += 1
      end

      raw(content += "</ol>")
    end

  end
end
