# Definition: rsync::server::module
#
# sets up a rsync server
#
# Parameters:
#   $path             - path to data
#   $comment          - rsync comment
#   $read_only        - yes||no, defaults to yes
#   $write_only       - yes||no, defaults to no
#   $list             - yes||no, defaults to yes
#   $uid              - uid of rsync server, defaults to 0
#   $gid              - gid of rsync server, defaults to 0
#   $incoming_chmod   - incoming file mode, defaults to 0644
#   $outgoing_chmod   - outgoing file mode, defaults to 0644
#   $max_connections  - maximum number of simultaneous connections allowed, defaults to 0
#   $lock_file        - file used to support the max connections parameter, defaults to /var/run/rsyncd.lock
#    only needed if max_connections > 0
#   $secrets_file     - path to the file that contains the username:password pairs used for authenticating this module
#   $auth_users       - list of usernames that will be allowed to connect to this module (must be undef or an array)
#   $hosts_allow      - list of patterns allowed to connect to this module (man 5 rsyncd.conf for details, must be undef or an array)
#   $hosts_deny       - list of patterns allowed to connect to this module (man 5 rsyncd.conf for details, must be undef or an array)
#   $transfer_logging - parameter enables per-file logging of downloads and 
#    uploads in a format somewhat similar to that used by ftp daemons.
#   $log_format       - This parameter allows you to specify the format used 
#    for logging file transfers when transfer logging is enabled. See the 
#    rsyncd.conf documentation for more details.
#   $refuse_options   - list of rsync command line options that will be refused by your rsync daemon.
#   $log_file         - log messages to the indicated file rather than using syslog
#
#   sets up an rsync server
#
# Requires:
#   $path must be set
#
# Sample Usage:
#   # setup default rsync repository
#   rsync::server::module { 'repo':
#     path    => $base,
#     require => File[$base],
#   }
#
define rsync::server::module (
  $path,
  $order                              = "10_${name}",
  $comment                            = undef,
  $read_only                          = 'yes',
  $write_only                         = 'no',
  $list                               = 'yes',
  $uid                                = '0',
  $gid                                = '0',
  $incoming_chmod                     = '0644',
  $outgoing_chmod                     = '0644',
  $max_connections                    = '0',
  $lock_file                          = '/var/run/rsyncd.lock',
  $secrets_file                       = undef,
  Optional[Array] $exclude            = undef,
  Optional[Array] $auth_users         = undef,
  Optional[Array] $hosts_allow        = undef,
  Optional[Array] $hosts_deny         = undef,
  Optional[String] $pre_xfer_exec     = undef,
  Optional[String] $post_xfer_exec    = undef,
  $transfer_logging                   = undef,
  $log_format                         = undef,
  Optional[Array] $refuse_options     = undef,
  $ignore_nonreadable                 = undef,
  $log_file                           = undef)  {

  concat::fragment { "frag-${name}":
    content => epp('rsync/module.epp',{
      'name'               => $name,
      'path'               => $path,
      'order'              => $order,
      'comment'            => $comment,
      'read_only'          => $read_only,
      'write_only'         => $write_only,
      'list'               => $list,
      'uid'                => $uid,
      'gid'                => $gid,
      'incoming_chmod'     => $incoming_chmod,
      'outgoing_chmod'     => $outgoing_chmod,
      'max_connections'    => $max_connections,
      'lock_file'          => $lock_file,
      'secrets_file'       => $secrets_file,
      'exclude'            => $exclude,
      'auth_users'         => $auth_users,
      'hosts_allow'        => $hosts_allow,
      'hosts_deny'         => $hosts_deny,
      'transfer_logging'   => $transfer_logging,
      'log_format'         => $log_format,
      'refuse_options'     => $refuse_options,
      'ignore_nonreadable' => $ignore_nonreadable,
      'log_file'           => $log_file,
      'pre_xfer_exec'      => $pre_xfer_exec,
      'post_xfer_exec'     => $post_xfer_exec,
    }),
    target  => $rsync::server::conf_file,
    order   => $order,
  }
}
