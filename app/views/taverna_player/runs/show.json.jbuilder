json.partial! "info", :run => @run

json.partial! "inputs", :inputs => @run.inputs

if @run.outputs.size > 0
  json.outputs @run.outputs do |output|
    json.name output.name
    json.depth output.depth
    json.uri run_path(@run) + "/output/#{output.name}"
  end

  json.outputs_zip @run.results.url
end

unless @run.log.blank?
  json.log @run.log.url
end

unless @interaction.nil?
  json.interaction do
    json.id @interaction.unique_id
    json.serial @interaction.serial
    json.uri run_path(@run) + "/proxy/#{@interaction.unique_id}/page.html"
  end
end
