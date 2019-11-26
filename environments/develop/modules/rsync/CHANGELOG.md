##2017-04-13 - Release 0.6.2
###Summary
- Set conffile and service name for FreeBSD, https://github.com/puppetlabs/puppetlabs-rsync/pull/87
- New paramter to set syslog facility

##2017-02-08 - Release 0.6.1
###Summary
- New parameters
  - rsync::server::module
    - `$pre_xfer_exec`
    - `$post_xfer_exec`

##2017-01-05 - Release 0.6.0
###Summary
Force array type for array params of rsync::server::module. 
In previous versions it was possible to pass string values for array params. The switch to epp
let to string values split by character

##2016-12-15 - Release 0.5.3
###Summary
This release replaces erb templates with epp templates

##2016-10-04 - Release 0.5.2
###Summary
This release improves test and metadata

####Features
- Add metadata_lint check
- Add os_supportt metadata
- Bound ranges for dependencies
- Add tags

##2016-10-05 - Release 0.5.1
###Summary
This release includes new parameters.

####Features
- New parameters
  - rsync::server::module
    - `$log_file`
    - `$ignore_nonreadable`


##2016-09-21 - Release 0.5.0
###Summary
This release includes several new parameters and puppet 4 support.

####Features
- Add SuSE and RedHat support
- New parameters
  - rsync
    - `$manage_package`
    - `$puts`
    - `$gets`
  - rsync::server
    - `port`
  - rsync::server::module
    - `transfer_logging`
    - `log_format`

####Bugfixes
- Fix testing
- Compatibility with puppet 4 and future parser


##2015-01-20 - Release 0.4.0
###Summary

This release includes several new parameters and improvements.

####Features
- Update `$include` and `$exclude` to support arrays
- Updated to use puppetlabs/concat instead of execs to build file!
- New parameters
  - rsync::get
    - `$options`
    - `$onlyif`
  - rsync::put
    - `$include`
    - `$options`
  - rsync::server::module
    - `$order`
    - `$refuse_options`

####Bugfixes
- Fix auto-chmod of incoming and outgoing files when `incoming_chmod` or `outgoing_chmod` is set to false

##2014-07-15 - Release 0.3.1
###Summary

This release merely updates metadata.json so the module can be uninstalled and
upgraded via the puppet module command.

##2014-06-18 - Release 0.3.0
####Features
- Added rsync::put defined type.
- Added 'recursive', 'links', 'hardlinks', 'copylinks', 'times' and 'include'
parameters to rsync::get.
- Added 'uid' and 'gid' parameters to rsync::server
- Improved support for Debian
- Added 'exclude' parameter to rsync::server::module

####Bugfixes
- Added /usr/local/bin to path for the rsync command exec.


##2013-01-31 - Release 0.2.0
- Added use_chroot parameter.
- Ensure rsync package is installed.
- Compatability changes for Ruby 2.0.
- Added execuser parameter to run command as specified user.
- Various typo and bug fixes.

##2012-06-07 - Release 0.1.0
- Initial release
