
==============================================================================

An example initializer has been installed to:

  config/initializers/taverna_player.rb.example

Please look through this file and make any alterations as required. BEFORE you
configure the Taverna Server URI and login information copy this file to:

  config/initializers/taverna_player.rb

Then check the example file into your repository, add the non-example file to
your version control ignore file (e.g. .gitignore) and then configure the
sensitive Taverna Server information. This allows you to check in most of the
Taverna Player configuration, leaving the sensitive parts out.

In your application's install instructions remember to tell your users to copy
the example initializer and configure their Taverna Server information.

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

  4. Taverna Player comes with some very simple, unstyled views and layouts.
     If you wish to override these with your own customized views you can copy
     them into your application with:

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

  6. If you need to override the Taverna Player Run model, to add columns to
     the table for example, you can copy a customizable stub with:

       rails generate taverna_player:models

     The stub is copied to the app/models/taverna_player directory so that it
     takes precedence over the default one.

  7. If you want to use pre- and post-run callbacks you can setup some basic
     stubs with:

       rails generate taverna_player:callbacks

     They will be saved to "lib/taverna_player_callbacks.rb". Don't forget to
     then require and register them in the Taverna Player initializer.

  8. You can add to, or change, the workflow run outputs render methods to
     better suit your particular application. To copy the defaults that
     Taverna Player ships with into your application for customization run:

       rails generate taverna_player:renderers

     They will be saved to "lib/taverna_player_renderers.rb". Don't forget to
     then require and register them in the Taverna Player initializer.

==============================================================================
