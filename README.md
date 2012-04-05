# Capistrano::Blaze

[![Build Status](https://secure.travis-ci.org/iain/capistrano-blaze.png?branch=master)](http://travis-ci.org/iain/capistrano-blaze)

This tiny gem notifies you on Campfire when you use Capistrano.  The only
thing you have to configure is your Campfire credentials, the proper hooks are
automatically added.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'capistrano-blaze', :require => false
```

Add to your `config/deploy.rb`:

``` ruby
require 'capistrano/blaze'

Capistrano::Blaze.configure do |config|
  config.account = "your-subdomain"
  config.room_id = 12345
  config.token   = "abcd"
  config.ssl     = true
end
```

To test your configuration, run:

``` shell
$ cap campfire:test_config
```

## Todo

* Configure what kinds of messages are displayed

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
