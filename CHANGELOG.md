### master (unreleased)

Breaking Changes:

* Removes HelpScout::Configuration#access_token and writer to avoid multiple sources
  of truth for access token values (#14)

Enhancements:

* Adds support for `HelpScout::Thread.create`, `HelpScout::Thread.get`, and
  `HelpScout::Thread#update` (Justin White, [#13](https://github.com/taxjar/help_scout-sdk/pull/13))

### 1.1.0 / 2019-06-20

### 1.0.2 / 2019-06-07

### 1.0.1 / 2019-06-07

### 1.0.0 / 2019-06-05

Breaking Changes:

* Drops support for the Mailbox 1.0 API ([#2](https://github.com/taxjar/help_scout-sdk/pull/2))

Enhancements:

* Updated to support the Mailbox 2.0 API ([#2](https://github.com/taxjar/help_scout-sdk/pull/2))
