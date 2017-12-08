# AttendeaseSDK

Put your Ruby code in the file `lib/attendease_sdk`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attendease_sdk'
```

And then execute:

    $ bundle

You need to install the SDK via the Gemfile that references the SDK's Github repo:
    $ gem 'attendease_sdk', :git => 'git@attendease-sdk-ruby.github.com:attendease/attendease-sdk-ruby.git', :ref => '617f7dedfc5a72d2921ee4501ea84bcb9e31c8b4'

    (where ref is the SHA of the commit to reference)

NOTE: the `client-integration` project relies on the Gemfile from the `Attendease` project.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/attendease_sdk.
