json.inputs inputs do |input|
  json.name input.name
  if input.file.blank?
    json.value input.value
  else
    json.file_uri input.file.url
  end
end
