
==============================================================================

Two initializers have been installed to:

  config/initializers/taverna_player.rb
  config/initializers/taverna_server.example.rb

The first is general configuration for Taverna Player and it is safe to commit
this to your repository. The second is configuration specific to your Taverna
Server instance and should not be commited to your repository. Please look
through these files and make any alterations as required. BEFORE you configure
the Taverna Server URI and login information in taverna_server.example.rb copy
this file to:

  config/initializers/taverna_server.rb

Then check the example file into your repository, add the non-example file to
your version control ignore file (e.g. .gitignore) and then configure the
sensitive Taverna Server information. This allows you to check in most of the
Taverna Player configuration, leaving the sensitive parts out.

In your application's install instructions remember to tell your users to copy
the example initializer and configure their Taverna Server information.

A locale file has also been installed to:

  config/locales/taverna_player.en.yml

Please edit this to suit your application if required.

There is also some manual setup to do, if you haven't already done it:

  1. Mount the Taverna Player engine in your config/routes.rb. For example:

       mount TavernaPlayer::Engine, :at => "/"

     You can also nest the Taverna Player runs resources within your workflows
     resources if you wish, like this:

       resources :workflows do
         resources :runs, :controller => "TavernaPlayer::Runs",
           :except => :edit
       end

     The runs resources in Taverna Player do not provide an edit view by
     default so, unless you add it yourself by overriding the controller you
     should add the :except clause to the routes.

  2. Perform Taverna Player's migrations:

       rake taverna_player:install:migrations
       rake db:migrate

  3. Make sure you have defined root_url to something in your config/routes.rb.
     For example:

       root :to => "home#index"

  4. Add Taverna Player's assets to your application's manifests.
     In app/assets/javascripts/application.js:

       //= require taverna_player/application

     In app/assets/stylesheets/application.css

       *= require taverna_player/application

     And everything should be found by the asset pipeline automatically.

  5. Make sure you have flash messages in your main layout
     (usually app/views/layouts/application.html.erb). For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

  6. Taverna Player uses delayed_job to run workflows on a Taverna Server. If
     your application is not already using delayed_job then you can install
     the delayed_job script in your "script" directory with:

       rails generate taverna_player:job

  7. Taverna Player comes with some very simple, unstyled views and layouts.
     If you wish to override these with your own customized views you can copy
     them into your application with:

       rails generate taverna_player:views

     The views are copied to the app/views/taverna_player directory so that
     they take precedence over the default ones. You can delete any that you
     do not need to customize but there are no penalties for leaving them
     there.

  8. If you need to override the Taverna Player controllers, to implement user
     authorization for example, you can copy some customizable stubs with:

       rails generate taverna_player:controllers

     The stubs are copied to the app/controllers/taverna_player directory so
     that they take precedence over the default ones. You can delete any that
     you do not need to customize but there are no penalties for leaving them
     there.

  9. If you need to override the Taverna Player Run model, to add columns to
     the table for example, you can copy a customizable stub with:

       rails generate taverna_player:models

     The stub is copied to the app/models/taverna_player directory so that it
     takes precedence over the default one.

 10. If you want to use pre- and post-run callbacks you can setup some basic
     stubs with:

       rails generate taverna_player:callbacks

     They will be saved to "lib/taverna_player_callbacks.rb". Don't forget to
     then require and register them in the Taverna Player initializer.

 11. You can add to, or change, the workflow port render methods to better
     suit your particular application. To copy the defaults that Taverna
     Player ships with into your application for customization run:

       rails generate taverna_player:renderers

     They will be saved to "lib/taverna_player_renderers.rb". Don't forget to
     then require and register them in the Taverna Player initializer.

==============================================================================
