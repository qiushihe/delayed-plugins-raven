# Delayed::Plugins::Raven

![Looking for maintainer](https://raw.github.com/qiushihe/delayed-plugins-raven/master/resources/looking-for-maintainer.png)

DelayedJob exception notification with Sentry Raven

Based on Ben Oakes's AirBrake plugin (https://github.com/benjaminoakes/delayed-plugins-airbrake) with samples provided by Bruno Miranda (https://gist.github.com/brupm/3c7056b03d62ba415015).

## Installation

Add this line to your application's Gemfile:

    gem 'delayed-plugins-raven'

## Usage

Register the plugin like so:

    require 'delayed-plugins-raven'
    Delayed::Worker.plugins << Delayed::Plugins::Raven::Plugin

In a Rails project, this can be done in `config/initializers`.

## Optional Configuration

To configure `Delayed::Plugins::Raven` independently from the default Raven configuration, add an initializer to `config/initializers`:

    require 'delayed-plugins-raven'
    Delayed::Plugins::Raven.configure do |config|
      config.dsn = ENV["SENTRY_DSN"]
      config.excluded_exceptions = []
      ...
    end

If this configuration is omitted, `Raven.capture_exception` will be invoked with the default Raven configuration.
