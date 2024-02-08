# chartmogul-ruby Change Log

## Version 4.2.0 - February 8, 2024
- Add support for customer's `website_url` attribute
- Add support for customer's subscription `uuid` attribute

## Version 4.1.0 - December 20, 2023
- Adds support for Customer Notes

## Version 4.0.1 - November 7 2023
- Add upgrade guide from v3.x to v4.x

## Version 4.0.0 - November 1 2023
- Remove support for old pagination using `page` parameter.
- Drop support for Ruby versions below 2.7.

## Version 3.3.1 - October 27 2023
- Add support for cursor based pagination to `.all` endpoints.
- Add `.next` pagination method for all supported cursor based endpoints.
- Move `fixtures/` folder inside the `spec/` folder.
- Update `.merge!` methods to always return `true` when successful.
- Add new attributes to `ChartMogul::Customer` resource.
- Do not error when the server returns an empty body from `.custom!` methods.

## Version 3.3.0 - August 14 2023
- Fix an issue with creating using `SubscriptionEvents.create!(attrs)`.

## Version 3.2.0 - June 14 2023
- Adds support for Faraday 2.7
- Removes support for Ruby 2.3, 2.4, and 2.5

## Version 3.1.0 - Mar 30 2023
- Adds support for Contacts (https://dev.chartmogul.com/reference/contacts)

## Version 3.0.2 - 22 Jun 2022
- Adds percentage change support

## Version 3.0.1 - 30 May 2022
- Add Subscription Events support

## Version 3.0.0 - 29 October 2021
- Update ChartMogul::Configuration to use `api_key` instead of `account_token`& `secret_key` combo for authentication
- Send library version as part of `User-Agent` header

## Version 2.9.0 - 3 Nov 2021
- Adds post install message informing about authentication changes *& deprecation warning.

## Version 2.1.0 - 9 July 2021
- Adds ChartMogul::Metrics::ActivitiesExport class to support async activities export endpoint

## Version 2.0.0 - 25 June 2021
- Moves customer scoped Metrics::Activities and Metrics::Subscriptions under Metrics::Customers namespace
- Adds unscoped activities API endpoint

## Version 1.7.2 - 16 March 2021
- Fix bug preventing instantiating attributes on ChartMogul::Customers objects

## Version 1.7.1 - 8 March 2021
- Adds amount_in_cents to payment for partial payments
- Adds account API endpoint

## Version 1.6.9 - 10 December 2020
- Fix ChartMogul::Customers class

## Version 1.6.8 - 1 November 2020
- Add support for subscription_external_id when listing Activities

## Version 1.6.7 - 8 September 2020
- Allow adding Customer custom attributes in camel case

## Version 1.5.0 - 20 February 2020
- Add support for plan groups API

## Version 1.4.0 - 20 September 2019
- Add support for subscription sets

## Version 1.3.1 - 6 May 2019
- Add #last method to Entries

## Version 1.3.0 - 5 March 2019
- Method #update_cancellation_dates added to allow users to update the cancellation dates on subscription.

## Version 1.2.2 - 21 December 2018
- Added connect subscriptions method

## Version 1.2.1 - 11 September 2018
- Update Faraday dependency version

## Version 1.2.0 - 15 August 2018
- Rertry requests on certain statuses and allow config

## Version 1.1.8 - 22 June 2018
- Fix ChartMogul::ChartMogulError class

## Version 1.0.2 - 6 March 2017
- Consolidated Customer, Enrichment/Customer now deprecated

## Version 1.0.1 - 21 February 2017
- Fixed all() in Customer, now returns Customers with paging

## Version 1.0.0 - 14 February 2017
- Add support for new plan and data source endpoints
- Remove deprecated Import namespace

## Version 0.1.4 - 10 November 2016
- Add support for merging customers
- Add support for updating customers

## Version 0.1.3 - 8 November 2016
- Add support for lead_created_at and free_trial_started_at fields to work with Leads and Trials charts

## Version 0.1.2 - 13 July 2016
- Fix bug preventing cancellation of subscriptions [#22]

## Version 0.1.1 - 4 July 2016
- Version bump after 0.1.0 pushed to RubyGems under incorrect account.

## Version 0.1.0 - 4 July 2016
- Initial release with support for our Import, Enrichment and Metrics APIs.
