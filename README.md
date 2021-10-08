# RailsCredentialsGit

Have you ever been in the situation where you'd like to see the changes you made in your encrypted credentials when using `git diff` ? Or worse, having conflicts on the same credentials and only seeing two different encrypted strings ?

A good stackoverflow solutions is to use `bin/rails encrypted:show`, but this will have to load your entire app not once but twice, resulting in having to wait a long (depending on your app size) time each time you diff credentials.

This gem brings you the same functionnality, at the fraction of the time, in less than 100 lines of code.

It has been tested successfully with Rails 5.2, 6.0 and 6.1.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-credentials-git', group: :development, require: false
```

And then execute:

```sh
$ bundle install
```

Finally, run the following to have the ruby binary copied into your project's `bin/` folder:

```sh
$ bundle exec rails_credentials_git install
```

## Configuration

Now we're going to configure `git` to use the binary you just installed. Add these lines to your `.git/config` file at the root of your project:

```
[diff "enc"]
  textconv = ruby --disable-gems bin/enc
  cachetextconv = false
```

It defines a new diff mode named "enc", using our Rails binary to do the text conversion. Since it does not use any gem, we can use the `--disable-gems` option to speed up the execution.
The `cachetextconv = false` option, specify that git should not cache the text conversion which in our case would be the decrypted credentials.

Finally, create a `.gitattributes` file at the root of your project or edit your existing one with the following lines:

```
*.yml.enc diff=enc -merge
```

It instructs git to use you newly define mode "enc" when diff-ing files matching the `*.yml.enc` regexp.

If you're using a default Rails installation, everything is set up and you can now modify your credentials file and use `git diff` to see the results. If you're using a custom location for your `master.key`, you can use the env variable `RAILS_MASTER_KEY` (which is also used by Rails) to pass your key directly.

## Usage

In addition, you can use this gem's binary during git conflicts (merge or rebase). Using

```sh
bin/enc --conflict # with RAILS_MASTER_KEY set if you need to
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ccocchi/rails-credentials-git. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ccocchi/rails-credentials-git/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
