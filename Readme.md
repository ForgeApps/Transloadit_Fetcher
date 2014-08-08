# transloadit_fetcher
If you use [Transloadit](http://transloadit.com) and their Assembly Notifications (webhooks) then Transloadit Fetcher can help make your local development far easier.

In order to simulate the notification process you must visit your Transloadit dashboard, view your assemblies, find the one you care about, view the JSON that it outputs, and then manually POST that to your local development server. Transloadit-Fetcher automates this process.

It checks for new assemblies every minute, only fetching ones created since it last found any assemblies. It pulls these down, and performs a POST to a URL of your choosing that emulates the Transloadit assembly notification.

The current version is **0.0.2**

# Installation

In your gemfile:

`gem 'transloadit_fetcher', group :development`

In your terminal:

`bundle install`


# Usage
Find your API Key and Secret here: https://transloadit.com/accounts/credentials

`bundle exec transloadit_fetcher -l my_api_key my_api_secret http://127.0.0.1:3000`

The `-l` tells it to loop and check every 1 minute.

#### ToDo:

* Improve handling of first fetch. It probably should just fetch all assemblies that were created in the last minute
* Add some better output depending on the response code of the HTTP POST.
* General Code cleanup


#### Changelog:
0.0.2 - Fix bug causing `since` parameter to be lost.

0.0.1 - Initial release