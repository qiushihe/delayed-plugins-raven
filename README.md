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
