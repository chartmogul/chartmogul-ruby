<p align="center">
<a href="https://chartmogul.com"><img width="200" src="https://user-images.githubusercontent.com/5329361/42206299-021e4184-7ea7-11e8-8160-8ecd5d9948b8.png"></a>
</p>

<h3 align="center">Official ChartMogul API Ruby Client</h3>

<p align="center"><code>chartmogul-ruby</code> provides convenient Ruby bindings for <a href="https://dev.chartmogul.com">ChartMogul's API</a>.</p>

<p align="center">
  <a href="https://badge.fury.io/rb/chartmogul-ruby"><img src="https://badge.fury.io/rb/chartmogul-ruby.svg" alt="Gem Version"></a>
  <a href="https://travis-ci.org/chartmogul/chartmogul-ruby"><img src="https://travis-ci.org/chartmogul/chartmogul-ruby.svg?branch=master" alt="Travis project"></a>
  <a href="https://codeclimate.com/github/chartmogul/chartmogul-ruby/test_coverage"><img src="https://api.codeclimate.com/v1/badges/40e8bdff4d1dbf2451de/test_coverage" /></a>
</p>

<hr>

<p align="center">
<b><a href="#installation">Installation</a></b>
|
<b><a href="#configuration">Configuration</a></b>
|
<b><a href="#usage">Usage</a></b>
|
<b><a href="#development">Development</a></b>
|
<b><a href="#contributing">Contributing</a></b>
|
<b><a href="#license">License</a></b>
</p>

<hr>
<br>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chartmogul-ruby', require: 'chartmogul'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chartmogul-ruby

### Supported Ruby Versions
This gem supports Ruby 2.3 and above.

## Configuration

Configure `chartmogul-ruby` with your Account Token and Secret Key, available from the administration section of your ChartMogul account.

```ruby
ChartMogul.account_token = '<Account key goes here>'
ChartMogul.secret_key = '<Secret key goes here>'
```

Configuration is threadsafe and applied only to the current thread.

Test your authentication:
```ruby
ChartMogul::Ping.ping
```

## Usage

For example, to create a Data Source object,

Request:
```ruby
ChartMogul::DataSource.create!(
  name: 'In-house billing'
)
```

Response:
```ruby
#<ChartMogul::DataSource:0x007ff9f127d628
@name="In-house billing",
@uuid="ds_cfc2b8f2-ad2c-4e3d-b64f-58d0bb282824",
@status="never_imported",
@created_at=2016-06-27 11:27:37 UTC
>
```

You can find examples for each endpoint in the ChartMogul [API documentation](https://dev.chartmogul.com/).

[![https://gyazo.com/f7a2a1b86a409586ee8dd0f4f7563937](https://i.gyazo.com/f7a2a1b86a409586ee8dd0f4f7563937.gif)](https://i.gyazo.com/f7a2a1b86a409586ee8dd0f4f7563937.gif)

## Rate Limits & Exponential Backoff

The library will keep retrying if the request exceeds the rate limit or if there's any network related error. By default, the request will be retried for 20 times (approximated 15 minutes) before finally giving up.

You can change the retry count with:
```ruby
ChartMogul.max_retries = 15
```
Set it to 0 to disable it.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chartmogul/chartmogul-ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

### The MIT License (MIT)

*Copyright (c) 2020 ChartMogul Ltd.*

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
