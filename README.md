# Capistrano::Blaze

Because Capistrano::Campfire had to many dependencies and a hard setup, this is
my attempt at making it easier.

This gem has no runtime dependencies and should just work right out of the box.
All you need to do is to provide your Campfire credentials.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'capistrano-blaze', :require => false
```

And then execute:

``` shell
$ bundle
```

Or install it yourself as:

``` shell
$ gem install capistrano-blaze
```

## Usage

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
* Don't depend on the multistage extension

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
