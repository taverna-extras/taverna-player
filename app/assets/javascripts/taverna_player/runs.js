//-----------------------------------------------------------------------------
// Copyright (c) 2013 The University of Manchester, UK.
//
// BSD Licenced. See LICENCE.rdoc for details.
//
// Taverna Player was developed in the BioVeL project, funded by the European
// Commission 7th Framework Programme (FP7), through grant agreement
// number 283359.
//
// Author: Robert Haines
//-----------------------------------------------------------------------------

// Copied from http://www.netlobo.com/url_query_string_javascript.html
function getParameterValue(name) {
  name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
  var regexS = "[\\?&]" + name + "=([^&#]*)";
  var regex = new RegExp(regexS);
  var results = regex.exec(window.location.href);

  if (results == null)
    return "";
  else
    return results[1];
}

function interaction_reply(url, status, results) {
  var outputData = JSON.stringify(results);

  jQuery.ajax({
    url: url,
    type: "POST",
    async: false,
    data: outputData,
    headers: {
      "Content-Type": "application/json",
      "X-Taverna-Interaction-Reply": escape(status),
      "X-CSRF-Token": jQuery('meta[name="csrf-token"]').attr("content")
    }
  });

  return false;
}
