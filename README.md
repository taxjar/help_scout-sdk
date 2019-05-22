# Help Scout API Wrapper

🚨 WORK IN PROGRESS 🚨

This gem is a wrapper around the Helpscout API. The current version is targeting the [Mailbox 2.0 API](https://developer.helpscout.com/mailbox-api/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'helpscout', git: "https://github.com/taxjar/helpscout.git"
```

And then execute:

    $ bundle

## Progress

| Models                     | List | Get  | Create  | Update | Delete  |
| :------------------------- | :--: | :--: | :-----: | :----: | :-----: |
| Attachment                 |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |
| Attachment::Data           |   ❌  |  ❌  |    ❌   |    ❌   |    ❌   |
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
Helpscout.configure do |config|
  config.app_id = ENV["HELPSCOUT_APP_ID"]
  config.app_secret = ENV["HELPSCOUT_APP_SECRET"]

  config.access_token = Helpscout::AccessToken.create
end
```

### Conversations

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/conversations/list/)

```ruby
Helpscout::Conversation.list
location = Helpscout::Conversation.create(...)
conversation = Helpscout::Conversation.get(location.split("/").last)
conversation.update("replace", "/subject", "New Subject")
```

### Customers

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/customers/list/)

```ruby
Helpscout::Customer.list
Helpscout::Customer.get(id)
```

### Mailboxes

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/mailboxes/list/)

```ruby
Helpscout::Mailbox.list
mailbox = Helpscout::Mailbox.get(id)
mailbox.fields
mailbox.folders
```

### Users

[Documentation Link](https://developer.helpscout.com/mailbox-api/endpoints/users/list/)

```ruby
Helpscout::User.list
user = Helpscout::User.get(id)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taxjar/helpscout. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the H2 project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/taxjar/helpscout/blob/master/CODE_OF_CONDUCT.md).
