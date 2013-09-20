
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

  4. Taverna Player comes with some very simple, unstyled views. If you wish
     to override these with your own customized views you can copy them into
     you application with:

       rails generate taverna_player:views

     The views are copied to the app/views/taverna_player directory so that
     they take precedence over the default ones. You can delete any that you
     do not need to customize but there are no penalties for leaving them
     there.

  5. If you need to override the Taverna Player controllers, to implement user
     authorization for example, you can copy some customizable stubs with:

       rails generate taverna_player:controllers

     The stubs are copied to the app/controllers/taverna_player directory so
     that they take precedence over the default ones. You can delete any that
     you do not need to customize but there are no penalties for leaving them
     there.

  6. If you want to use pre- and post-run callbacks you can setup some basic
     stubs with:

       rails generate taverna_player:callbacks

     Don't forget to then require and register them in the Taverna Player
     initializer.

==============================================================================
