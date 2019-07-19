# Help Scout API Wrapper

[![Build Status](https://travis-ci.org/taxjar/help_scout-sdk.svg?branch=master)](https://travis-ci.org/taxjar/help_scout-sdk)
[![Gem Version](https://badge.fury.io/rb/help_scout-sdk.svg)](https://badge.fury.io/rb/help_scout-sdk)

This gem is a wrapper around the Help Scout API. The current version is targeting the [Mailbox 2.0 API](https://developer.helpscout.com/mailbox-api/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "help_scout-sdk"
```

And then execute:

    $ bundle

## Progress

| Models                     | List | Get  | Create  | Update | Delete  |
| :------------------------- | :--: | :--: | :-----: | :----: | :-----: |
| Attachment                 |   ❌  |  ❌  |    ✅   |    ❌   |    ❌   |
| Conversations              |   ✅  |  ✅  |    ✅   |    ✅   |    ❌   |
| Conversation::Threads      |   ✅  |  ➖  |    ✅   |    ✅   |    ➖   |
| Customers                  |   ✅  |  ✅  |    ❌   |    ❌   |    ❌   |
| Notes                      |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |
| Mailboxes                  |   ✅  |  ✅  |    ➖   |    ➖   |    ➖   |
| Mailbox::Folders           |   ✅  |  ➖  |    ➖   |    ➖   |    ➖   |
| Mailbox::Workflows         |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |
| Tags                       |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |
| Teams                      |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |
| Team::Members              |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |
| Users                      |   ✅  |  ✅  |    ❌   |    ❌   |    ❌   |
| Workflows                  |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |

| Endpoint | Supported |
| -------- | :-------: |
| Reports  |     ❌     |
| Search   |     ❌     |
| Webhooks |     ❌     |

## Usage

### Configuration

```ruby
HelpScout.configure do |config|
  config.app_id = ENV["HELP_SCOUT_APP_ID"]
  config.app_secret = ENV["HELP_SCOUT_APP_SECRET"]
end
```

### Conversations

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/conversations/list/)

```ruby
HelpScout::Conversation.list
location = HelpScout::Conversation.create(...)
conversation = HelpScout::Conversation.get(location.split("/").last)
conversation.update("replace", "/subject", "New Subject")
```

### Customers

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/customers/list/)

```ruby
HelpScout::Customer.list
HelpScout::Customer.get(id)
```

### Mailboxes

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/mailboxes/list/)

```ruby
HelpScout::Mailbox.list
mailbox = HelpScout::Mailbox.get(id)
mailbox.fields
mailbox.folders
```

### Threads

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/conversations/threads/list/)

```ruby
conversation = HelpScout::Conversation.list.first
new_thread = HelpScout::Thread.create(conversation.id, "notes", { text: 'Hello, world!' })
threads = HelpScout::Thread.list(conversation.id)
latest_thread = threads.first
latest_thread.update("replace", "/text", "Updating a threads text.")
modified_thread = HelpScout::Thread.get(conversation.id, latest_thread.id)
```

### Users

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/users/list/)

```ruby
HelpScout::User.list
user = HelpScout::User.get(id)
```

### Caching Access Tokens

Since short-lived access tokens aren't likely to be embedded into environment variables, it can be difficult to share them across processes. To work around this, you can configure a `token_cache` (and optional `token_cache_key`) to be used to store and retrieve the token until expiry. In general any object that conforms to the `ActiveSupport::Cache::Store` API should work. For example, using an application's Rails cache:

```ruby
HelpScout.configuration.token_cache = Rails.cache
HelpScout.configuration.token_cache_key
# => 'help_scout_token_cache'
HelpScout.configuration.token_cache_key = 'my-own-key'
```

With caching configured, whenever the gem attempts to create an access token, it will first attempt to read a value from the cache using the configured cache key. If it's a hit, the cached values will be used to create a new `AccessToken`. If it's a miss, then the gem will make a request to the Help Scout API to retrieve a new token, writing the token's details to the cache before returning the new token.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taxjar/help_scout-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the H2 project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/taxjar/help_scout-sdk/blob/master/CODE_OF_CONDUCT.md).
