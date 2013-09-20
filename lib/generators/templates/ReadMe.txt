
==============================================================================

An initializer has been installed to config/initializers/taverna_player.rb.
Please look through this file and make any alterations as required.

There is also some manual setup to do, if you haven't already done it:

  1. Mount the Taverna Player engine in your config/routes.rb. For example:

       mount TavernaPlayer::Engine, :at => "/"

  2. Make sure you have defined root_url to something in your config/routes.rb.
     For example:

       root :to => "home#index"

  3. Make sure you have flash messages in your main layout
     (usually app/views/layouts/application.html.erb). For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

==============================================================================
