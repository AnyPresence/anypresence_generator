# ***[Application Name]*** UI Documentation

## Description

***[A description of the type of UI along with the app name.]***

## Table of Contents

- [Project Structure](#project-structure)
- [Opening the Project](#opening-the-project)
- [Setting up the Project](#setting-up-the-project)
- [Running the UI Project](#running-the-ui-project)
- [Development](#development)
- [Running the Tests](#running-the-tests)
- [Building the Project](#building-the-project)
- [Deploying the Project](#deploying-the-project)

## <a name="project-structure"></a> Project Structure

General description of the files and folders you will find within this UI project folder.

***[Below is an example from the jQuery UI README]***

* **app**
    * **assets** - This directory contains the application's source code
        * **images**
        * **javascripts**
            * **app**
                * **ap** - Anypresence namespace definition
                * **application** - Application namespace and class definition
                * **controller** - Application controller and authentication code
                * **init** - Application intialization code
                * **router** - Application router
                * **view** - Application views
            * **lib** - This directory contains the application's dependencies
        * **stylesheets** - This directory contains the application's stylesheets including dependencies
            * **app** - This directory contains application specfic stylesheets
* **custom** - Custom source code is stored in this directory and is incorporated into the app when it's built
    **javascripts - Custom javascripts
    **stylesheets - Custom stylesheets
* **public** - This directory contains the build files
* **templates** - This directory contains the main UI template
* **test** - This directory contains the application's tests
* Gemfile - The library definition manifest containing description, version and dependencies of this project's ruby gems
* Gruntfile.js - Grunt configuration and tasks, if you want to add code to this project you can use Grunt for development
* LICENSE.txt - The UI project license
* package.json - The library definition manifest containing description, version and dependencies of this project's node modules
* README.md - This file

## <a name="opening-the-project"></a> Opening the Project

***[How to open the project (i.e. the Xcode project for iOS or the Android Studio project for Android)]***

***[Example: requirements on Xcode or Android Studio versions]***

***[Below is an example from the jQuery UI README]***

The jQuery UI project can be opened in any conventional text editor (i.e. atom, vim) or ide (webstorm).

Running tests and building the project can both be accomplished directly from the command line.

## <a name="setting-up-the-project"></a> Setting up the Project

***[Section describing how to set up the UI project]***

***[Below is an example from the jQuery UI README]***

### Prerequisites

- [Ruby 2.1.0](http://www.ruby-lang.org/en/)
- [Bundler](http://gembundler.com)
- [NodeJS](http://nodejs.org)
- [CasperJS](http://casperjs.org)

### Install Ruby Gems

Make sure that bundler is installed first:

    gem install bundler

From the root directory of the application (where `Gemfile` is
located), install Ruby gems:

    bundle install

### Install NodeJS Modules

From the root directory of the application (where `Gruntfile.js` is located), install NodeJS modules:

      npm install

## <a name="running-the-ui-project"></a> Running the UI Project

***[Section describing how to run the UI project]***

***[Below is an example from the jQuery UI README]***

Run the application locally using [Pow](http://pow.cx).  After installing POW,  load the
app into POW by creating the following symlink:

    ln -s ~/path/to/<%=j application_definition.name.underscore %> ~/.pow/<%=j application_definition.name.underscore %>

Access the app in a browser at `http://<%=j application_definition.name.underscore %>.dev`.

Be sure the backend server is running at the URL specified in `AP.baseUrl`,
found in `/app/assets/javascripts/app/controller/main.js`.
Typically you'll develop against a local backend server, but you may also
develop against a remote server, such as a test or dev environment.

## <a name="development"></a> Development

***[Section describing how to setup the UI project for development]***

***[Below is an example from the jQuery UI README]***

Grunt is a NodeJS-based task runner.  It helps automate common tasks, such as
asset compilation, minification, and testing.  Grunt tasks are included for this
application in `Gruntfile.js`.

During development, a full minified application build is unnecessary.  To
recompile assets without minifying:

    grunt compile

Please note that `grunt build` must be run once before compiling. Normally `public/index.html` loads the fully compiled and minified assets. During development, however, it should load unminified assets.  Edit `public/index.html` and follow the directions in the comments to enable development.

### Automatic Compilation

Since it's cumbersome to manually compile assets after every change during
development, the application's `Gruntfile.js` includes a `watch` task.  The
task monitors changes to the application's `sass` assets,
automatically compiling (but not minifying) them.  Run the following command
before making changes:

    grunt watch

UI tests are also executed by the `watch` task.  When changing the UI
significantly, some or all tests may fail.  You may disable auto-testing by
editing the `watch` task in `Gruntfile.js`.

## <a name="running-the-tests"></a> Running the Tests

***[Section describing how to run the tests against the UI project]***

***[Below is an example from the jQuery UI README]***

The application comes with a complete UI test suite.  Execute tests from grunt:

    grunt test

## <a name="building-the-project"></a> Building the Project

***[Section describing how to build the UI project]***

***[Below is an example from the jQuery UI README]***

To compile assets and create a full minified production build, run the
build task:

    grunt build

## <a name="deploying-the-project"></a> Deploying the Project

***[Section describing how to deploy the UI project]***

***[Below is an example from the jQuery UI README]***

To deploy the project to S3 run the following deployment task:

    grunt deploy:production
