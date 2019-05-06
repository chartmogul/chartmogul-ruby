# chartmogul-ruby Change Log

## Version 1.3.1 - 6 May 2019
- Add #last method to Entries

## Version 1.3.0 - 5 March 2019
- Method #update_cancellation_dates added to allow users updating the cancellation dates on subscription. The previous one (#set_cancellation_dates) was not sending the update to Chartmogul API.

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
