karaf CHANGELOG
===============

This file is used to list changes made in each version of the karaf cookbook.

1.2.0 - 3/1/2016
-------------------
- Add bundle install feature.

1.1.0 - 2/25/2016
-------------------
- Add retry logic around core installation steps

1.0.2
-------------------
- Stabilizing race conditions with initial start and installing service-wrapper.

1.0.0 
-------------------
- Major update to use custom resource vs attribute-driven recipe
- Default install version to latest, 4.0.4
- Add support for customizing users and groups in `users.properties`

0.2.1 - 1/27/2016
-------------------
- Fixed issue where the initial start of karaf would not start as the defined service_user, which could cause problems for subsequent starts as service_user.

0.2.0 - 1/25/2016
-------------------
- Add support for specifying user with which to run service

0.1.0
-------------------
- Initial release of karaf
