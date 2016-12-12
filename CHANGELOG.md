karaf CHANGELOG
===============

This file is used to list changes made in each version of the karaf cookbook.

3.1.0 - !2/12/2016
-------------------
- Add option to `karaf_bundle` to start the bundle after installation.

3.0.0 - 11/29/2016
-------------------
- Support for newer Karaf versions
  - The automation using `bin/client` necessitated removing the user parameter. I *think* username karaf is used by 
    default and is able to authenticate when its a local connection.
- The `client_user` parameter was removed from the following resources. It may be added back at some point. The previous 
  bullet is the reason). 
  - `karaf_bundle`
  - `karaf_feature`
  - `karaf_feature_repository`

2.0.1 - 9/22/2016
-------------------
- Copy `karaf.service` to `/etc/systemd/system` to prevent possible issues with using symlink.

2.0.0 - 8/2/2016
-------------------
- Add support for `systemd` service. 
- Tested many patch version increments for Karaf with varying results. Documented in [README.md]().

1.2.1 - 3/16/2016
-------------------
- Automatically add the `group` role to new groups. 

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
