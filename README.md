# Help Scout API Wrapper

[![Build Status](https://travis-ci.org/taxjar/help_scout-sdk.svg?branch=master)](https://travis-ci.org/taxjar/help_scout-sdk)

🚨 WORK IN PROGRESS 🚨

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
| Conversation::Threads      |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |
| Conversation::ThreadSource |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |
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

  config.access_token = HelpScout::API::AccessToken.create
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

### Users

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/users/list/)

```ruby
HelpScout::User.list
user = HelpScout::User.get(id)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taxjar/help_scout-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the H2 project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/taxjar/help_scout-sdk/blob/master/CODE_OF_CONDUCT.md).
