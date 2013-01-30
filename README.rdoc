Introduction
============

`celltrack` is a [Ruby on Rails](http://rubyonrails.org) project for displaying the results of celltracking experiments. It is used in context of the experiments described [in this PLOS ONE paper](http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0027315).


Installation
============

- Install [Ruby](www.ruby-lang.org) and [Ruby on Rails](http://rubyonrails.org).
- Install [Node.js](http://nodejs.org) or any other Rails compatible JavaScript interpreter.
- If not present, install and start a database server, e.g. [MySQL](http://dev.mysql.com) or [PostgreSQL](http://www.postgresql.org).
- If not present, install [Git](http://git-scm.com).
- If not present, create an [GitHub](https://github.com) account, if you want to upload changes back to the repository.
- Clone [this repository](https://github.com/malteschmitz/celltrack).
- Copy one of the `celltrack/config/database.yml.[sqlite|mysql|postgres]` files to `celltrack/config/database.yml` and adjust the configuration according to the used database.
- Within a CLI, navigate to the `celltrack` folder.
- Execute `bundle install` to load all current gems (the first time and after every change in the repository).
- Execute `bundle exec rake db:setup` to initialise the development database.
- Execute `bundle exec rake db:setup RAILS_ENV=production` to initialise the production database.


Running
=======

In development mode
-------------------

- Execute `bundle exec rake assets:clean` to delete possible existing compiled assets.
- Execute `rails server` to run the server.
- In another CLI, execute `RAILS_ENV=production script/delayed_job start` or `bundle exec rake jobs:work` to run a worker for background processes ([delayed_job](https://github.com/collectiveidea/delayed_job)).

In production mode
-----------------

- Execute `bundle exec rake assets:precompile` to compile assets.
- Execute `rails server -e production` to run the server.
- In anoter CLI, execute `RAILS_ENV=production script/delayed_job start` or `bundle exec rake jobs:work RAILS_ENV=production` to run a worker for background processes ([delayed_job](https://github.com/collectiveidea/delayed_job)).


Data import
===========

Via data manually put on the server
-----------------------------------

- In the `celltrack/import` folder, create a new folder with sub-folders `cellmasks` and `statusflags` and fill these folders with the corresponding data.
- In the `celltrack/public` folder, create a new folder and fill this folder with the corresponding microscopy photographs. 
- In your browser, access `http://localhost:3000` and click the `New Experiment` button.
- Choose a name and a description for the experiment.
- In both list boxes, the before created folders should be displayed and can be chosen now.
- Check `Run import as background task`, if the import job should be started as a background process. Therefore, the worker must have been started before. Possible error messages are displayed in the output windows of the worker instead of the browser.
- Click `Create Experiment` to start the import job. Depending on the data volume, this can take a while. Watch the CLI.
- After finishing, the single photographs with the marked cells can be chosen and watched.

Via data uploaded as ZIP file
-----------------------------

- Prepare a ZIP file containing the two folders `cellmasks` and `statusflags` and fill these folders with the corresponding data.
- In the `celltrack/public` folder, create a new folder and fill this folder with the corresponding microscopy photographs. 
- In your browser, access `http://localhost:3000` and click the `New Experiment` button.
- Choose a name and a description for the experiment.
- In the lower list box, the before created folder containing the photographs should be displayed and can be chosen now.
- Check `Run import as background task`, if the import job should be started as a background process. Therefore, the worker must have been started before. Possible error messages are displayed in the output windows of the worker instead of the browser.
- Click `Create Experiment` to start the import job. Depending on the data volume, this can take a while. Watch the CLI.
- After finishing, the single photographs with the marked cells can be chosen and watched.


Delete background processes
===========================

If the import fails in the background process, the worker will try to re-start this process after a while. To delete such a (and all other), you can execute `bundle exec rake jobs:clear` or `bundle exec rake jobs:clear RAILS_ENV=production`.


Overview of *important files*
=============================

    celltrack
    |
    +-- app
    |   |
    |   +-- assets
    |   |   |
    |   |   +-- images.js                                // JavaScript for rendering and marking cells
    |   |   +-- experiments.js                           // JavaScript for showing the progress during the import
    |   |
    |   +-- controllers
    |   |   |
    |   |   +-- application_controller.rb                // Base class for Controllers
    |   |   +-- cells_controller.rb                      // Controller for the Cells resource
    |   |   +-- experiments_controller.rb                // Controller for the Experiment resource
    |   |   +-- iamges_controller.rb                     // Controller for the Image resource
    |   |
    |   +-- models
    |   |   |
    |   |   +-- cell.rb                                  // (Database) model of a cell
    |   |   +-- experiment.rb                            // (Database) model of a experiment
    |   |   +-- image.rb                                 // (Database) model of a picture
    |   |   +-- path.rb                                  // (Database) model of a path
    |   |   +-- picture.rb                               // (Database) model of a photograph
    |   |   +-- tree.rb                                  // (Database) model of a tree
    |   |
    |   +-- views
    |       |
    |       +-- experiments
    |       |   |
    |       |   +-- edit.html.erb                        // HTML: Edit an existing experiment
    |       |   +-- index.html.erb                       // HTML: Overview over all experiments
    |       |   +-- new.html.erb                         // HTML: Create a new experiment
    |       |   +-- show.html.erb                        // HTML: Show details (pictures) of an existing experiment
    |       |
    |       +-- images
    |       |   |
    |       |   +-- show.html.erb                        // HTML: Show details (cells) of an existing picture 
    |       |
    |       +-- layouts
    |           |
    |           +-- application.html.erb                 // Layout for all HTMLs
    |
    +-- config
    |   |
    |   +-- environment.rb                               // Configuration: paths to picture and import folders
    |   +-- routes.rb                                    // Configuration: URL forwarding
    |
    +-- db
    |   |
    |   +-- migrate
    |   |   |
    |   |   +-- {migrations}                             // Scripts for creating the database tables
    |   |
    |   +-- schema.rb                                    // Complete database model (auto-generated)
    |   +-- seeds.rb                                     // manually created minimal example
    |
    +-- import
    |   |
    |   +-- {Experiment}                                 // Sub-folders {Experiment} with sub-sub-folders cellmasks and statusflags
    |
    +-- lib
    |   |
    |   +-- bit_vector.rb                                // Auxiliary class for bit vectors
    |   +-- experiment_parser.rb                         // Main import class
    |
    +-- public
        |
        +-- experiments
            |
            +-- {Experiment}                             // Sub-folders {Experiment} for microscopy photographs