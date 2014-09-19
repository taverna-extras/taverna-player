var search_data = {"index":{"searchIndex":["tavernaplayer","applicationhelper","portrenderer","run","runport","input","output","servicecredential","workflow","add()","cancelled?()","complete?()","create_time()","default()","description()","display_name()","embedded?()","failed?()","filename()","finish_time()","finished?()","has_parent?()","incomplete?()","initialized?()","inputs()","job_failed?()","list()","login()","metadata()","name()","name()","new_embedded_run_path()","new_embedded_run_url()","path()","pending?()","port_renderers()","render()","root_ancestor()","running?()","setup()","start_time()","state()","timeout?()","type_default()","uri()","user_model_proxy=()","value()","value_is_error?()","value_is_text?()","value_preview()","value_size()","value_size=()","value_type()","value_type=()","workflow_model_proxy()","changes","licence","readme"],"longSearchIndex":["tavernaplayer","tavernaplayer::applicationhelper","tavernaplayer::portrenderer","tavernaplayer::run","tavernaplayer::runport","tavernaplayer::runport::input","tavernaplayer::runport::output","tavernaplayer::servicecredential","tavernaplayer::workflow","tavernaplayer::portrenderer#add()","tavernaplayer::run#cancelled?()","tavernaplayer::run#complete?()","tavernaplayer::run#create_time()","tavernaplayer::portrenderer#default()","tavernaplayer::servicecredential#description()","tavernaplayer::runport#display_name()","tavernaplayer::run#embedded?()","tavernaplayer::run#failed?()","tavernaplayer::runport#filename()","tavernaplayer::run#finish_time()","tavernaplayer::run#finished?()","tavernaplayer::run#has_parent?()","tavernaplayer::run#incomplete?()","tavernaplayer::run#initialized?()","tavernaplayer::workflow#inputs()","tavernaplayer::run#job_failed?()","tavernaplayer::portrenderer#list()","tavernaplayer::servicecredential#login()","tavernaplayer::runport#metadata()","tavernaplayer::run#name()","tavernaplayer::servicecredential#name()","tavernaplayer::applicationhelper#new_embedded_run_path()","tavernaplayer::applicationhelper#new_embedded_run_url()","tavernaplayer::runport#path()","tavernaplayer::run#pending?()","tavernaplayer::port_renderers()","tavernaplayer::portrenderer#render()","tavernaplayer::run#root_ancestor()","tavernaplayer::run#running?()","tavernaplayer::setup()","tavernaplayer::run#start_time()","tavernaplayer::run#state()","tavernaplayer::run#timeout?()","tavernaplayer::portrenderer#type_default()","tavernaplayer::servicecredential#uri()","tavernaplayer::user_model_proxy=()","tavernaplayer::runport#value()","tavernaplayer::runport#value_is_error?()","tavernaplayer::runport#value_is_text?()","tavernaplayer::runport#value_preview()","tavernaplayer::runport#value_size()","tavernaplayer::runport#value_size=()","tavernaplayer::runport#value_type()","tavernaplayer::runport#value_type=()","tavernaplayer::workflow_model_proxy()","","",""],"info":[["TavernaPlayer","","TavernaPlayer.html","","<p>This module serves as the configuration point of Taverna Player. Examples\nof all configuration options …\n"],["TavernaPlayer::ApplicationHelper","","TavernaPlayer/ApplicationHelper.html","","<p>These helpers will be available in the main application when you use\nTaverna Player.\n"],["TavernaPlayer::PortRenderer","","TavernaPlayer/PortRenderer.html","","<p>This class manages the rendering of many different port types that could be\nassociated with a workflow. …\n"],["TavernaPlayer::Run","","TavernaPlayer/Run.html","","<p>This class represents a workflow run. It may be yet to run, running or\nfinished. All inputs and outputs …\n"],["TavernaPlayer::RunPort","","TavernaPlayer/RunPort.html","","<p>This class is the superclass of the input and output port types\nRunPort::Input and RunPort::Output, respectively. …\n"],["TavernaPlayer::RunPort::Input","","TavernaPlayer/RunPort/Input.html","","<p>This class represents a workflow input port. All functionality is provided\nby the RunPort superclass. …\n"],["TavernaPlayer::RunPort::Output","","TavernaPlayer/RunPort/Output.html","","<p>This class represents a workflow output port. All functionality is provided\nby the RunPort superclass. …\n"],["TavernaPlayer::ServiceCredential","","TavernaPlayer/ServiceCredential.html","","<p>This class represents a credential for authentication to a service during a\nworkflow run.\n"],["TavernaPlayer::Workflow","","TavernaPlayer/Workflow.html","","<p>This class represents a workflow. It is provided as an example model and\ncan be extended or replaced …\n"],["add","TavernaPlayer::PortRenderer","TavernaPlayer/PortRenderer.html#method-i-add","(mimetype, method, default = false)","<p>Add a renderer method for the specified MIME type. If you would like the\nrenderer to be the default for …\n"],["cancelled?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-cancelled-3F","","<p>Has this run been cancelled?\n"],["complete?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-complete-3F","","<p>Is this run complete? If a run is finished or cancelled or failed or its\nunderlying worker has failed …\n"],["create_time","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-create_time","","<p>The time this run was created on the Taverna Server.\n"],["default","TavernaPlayer::PortRenderer","TavernaPlayer/PortRenderer.html#method-i-default","(method)","<p>Set a default renderer for any MIME type not specifically set. This could\nbe used to supply a piece of …\n"],["description","TavernaPlayer::ServiceCredential","TavernaPlayer/ServiceCredential.html#method-i-description","","<p>The description of the service or credential.\n"],["display_name","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-display_name","","<p>Convert this port’s name to a more presentable form. In practice this means\nconverting underscores (_) …\n"],["embedded?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-embedded-3F","","<p>Is this run an embedded run? This helps determine if a run should be\ntreated differently, e.g. in the …\n"],["failed?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-failed-3F","","<p>Did this run finish abnormally or with an error?\n"],["filename","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-filename","","<p>Return a suitable filename to be used when saving data from a port. This is\ngenerated by concatenating …\n"],["finish_time","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-finish_time","","<p>The time this run finished running on Taverna Server.\n"],["finished?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-finished-3F","","<p>Has this run finished normally?\n"],["has_parent?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-has_parent-3F","","<p>A run will have a parent if it is a child run as part of a sweep.\n"],["incomplete?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-incomplete-3F","","<p>Is this run incomplete? If a run is pending or initialized or running then\nit is incomplete. #incomplete? …\n"],["initialized?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-initialized-3F","","<p>Is this run initialized on Taverna Server but not running yet?\n"],["inputs","TavernaPlayer::Workflow","TavernaPlayer/Workflow.html#method-i-inputs","","<p>Return a hash of information about this workflow’s inputs. The fields\nprovided are:\n<p><code>:name</code> - The name of ...\n"],["job_failed?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-job_failed-3F","","<p>Did the delayed_job worker running this run fail? This is primarily\nintended for internal use only at …\n"],["list","TavernaPlayer::PortRenderer","TavernaPlayer/PortRenderer.html#method-i-list","(method)","<p>Set a renderer to handle list ports. This will typically format the list\nsomehow and render the list …\n"],["login","TavernaPlayer::ServiceCredential","TavernaPlayer/ServiceCredential.html#method-i-login","","<p>The login name (or user name) used to log in to the service.\n"],["metadata","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-metadata","","<p>Get the size and type metadata for this port in a Hash. For a list it might\nlook like this:\n\n<pre>{\n  :size ...</pre>\n"],["name","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-name","","<p>The name (mnemonic) of this run.\n"],["name","TavernaPlayer::ServiceCredential","TavernaPlayer/ServiceCredential.html#method-i-name","","<p>The name of the service.\n"],["new_embedded_run_path","TavernaPlayer::ApplicationHelper","TavernaPlayer/ApplicationHelper.html#method-i-new_embedded_run_path","(id_or_model)","<p>Given a workflow instance, or workflow id, this method returns the URI path\nto a new embedded run of …\n"],["new_embedded_run_url","TavernaPlayer::ApplicationHelper","TavernaPlayer/ApplicationHelper.html#method-i-new_embedded_run_url","(id_or_model)","<p>Given a workflow instance, or workflow id, this method returns the full URI\nto a new embedded run of …\n"],["path","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-path","","<p>Return a url path segment that addresses this output value. Pass in a list\nof indices if it is a list …\n"],["pending?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-pending-3F","","<p>Is this run in the queue?\n"],["port_renderers","TavernaPlayer","TavernaPlayer.html#method-c-port_renderers","()","<p>Set up the renderers for each MIME type that you want to be able to show in\nthe browser. In most cases …\n"],["render","TavernaPlayer::PortRenderer","TavernaPlayer/PortRenderer.html#method-i-render","(port, index = [])","<p>This is the method that calls the correct renderer for the given port and\nreturns the resultant rendering. …\n"],["root_ancestor","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-root_ancestor","","<p>Gets the ultimate ancestor of this run, which may not be its immediate\nparent.\n"],["running?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-running-3F","","<p>Is this run still running on Taverna Server?\n"],["setup","TavernaPlayer","TavernaPlayer.html#method-c-setup","()","<p>Yield this configuration class so that Taverna Player can be set up.\n<p>See the taverna_player initializer …\n"],["start_time","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-start_time","","<p>The time this run started running on the Taverna Server.\n"],["state","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-state","","<p>The state of this run. Possible states are :pending, :initialized,\n:running, :finished, :cancelled, :timeout …\n"],["timeout?","TavernaPlayer::Run","TavernaPlayer/Run.html#method-i-timeout-3F","","<p>Did this run timeout?\n"],["type_default","TavernaPlayer::PortRenderer","TavernaPlayer/PortRenderer.html#method-i-type_default","(media_type, method)","<p>This is another way of setting the default renderer method for a whole\nmedia type (see the add method …\n"],["uri","TavernaPlayer::ServiceCredential","TavernaPlayer/ServiceCredential.html#method-i-uri","","<p>The URI of the service, returned as a string.\n"],["user_model_proxy=","TavernaPlayer","TavernaPlayer.html#method-c-user_model_proxy-3D","(user_class)","<p>Set up a proxy to the main application’s user model if it has one. The\nclass name should be supplied …\n"],["value","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-value","","<p>Return the value held in this port if there is one. Pass in a list of\nindices if it is a list port.\n<p>For …\n"],["value_is_error?","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-value_is_error-3F","","<p>Is the type of the value held in this port an error? Pass in a list of\nindices if it is a list port. …\n"],["value_is_text?","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-value_is_text-3F","","<p>Is the type of the value held in this port some sort of text? This returns\ntrue if the media type section …\n"],["value_preview","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-value_preview","","<p>Show up to the first 256 characters of the port’s value. This returns nil\nif the port has a file instead …\n"],["value_size","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-value_size","","<p>Get the size (in bytes) of the value held in this port. Pass in a list of\nindices if it is a list port. …\n"],["value_size=","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-value_size-3D","","<p>Set the size (in bytes) of the value held in this port. Pass in a list of\nsizes if it is a list port. …\n"],["value_type","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-value_type","","<p>Get the MIME type of the value held in this port. Pass in a list of indices\nif it is a list port. Returns …\n"],["value_type=","TavernaPlayer::RunPort","TavernaPlayer/RunPort.html#method-i-value_type-3D","","<p>Set the MIME type of the value held in this port. Pass in a list of types\nif it is a list port. This …\n"],["workflow_model_proxy","TavernaPlayer","TavernaPlayer.html#method-c-workflow_model_proxy","(workflow_class)","<p>Set up a proxy to the main application’s workflow model. The class name\nshould be supplied as a string, …\n"],["CHANGES","","CHANGES_rdoc.html","","<p>Changes log for Taverna Player\n<p>Version 0.9.0\n<p>Add a test to check if a Run’s delayed_job has failed.\n"],["LICENCE","","LICENCE_rdoc.html","","<p>Copyright © 2013, 2014 The University of Manchester, UK.\n<p>All rights reserved.\n<p>Redistribution and use …\n"],["README","","README_rdoc.html","","<p>Taverna Player\n<p>Authors &mdash; Robert Haines\n<p>Contact &mdash; support@mygrid.org.uk\n"]]}}