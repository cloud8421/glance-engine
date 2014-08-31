Glance
======

[![Build Status](https://travis-ci.org/cloud8421/glance-engine.svg?branch=master)](https://travis-ci.org/cloud8421/glance-engine)

Aggregates data from different sources. Used in personal dashboard.

The app requires the following environment variables:

    FORECAST_IO_API_KEY (forecast.io)
    GUARDIAN_API_KEY (Guardian beta content api)
    TFL_API_KEY (tfl api)
    WEEKEND_APP_ID (tfl app id)

Please follow the instructions on the relevant api providers sites to obtain them.

If you're using [direnv](http://direnv.net/), the project provides a
`.envrc.sample` file you can customize and rename.

## Setup

After taking care of the environment variables:

    $ mix deps.get
    $ iex -S mix

## Test

    $ mix test
