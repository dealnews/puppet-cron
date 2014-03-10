#
# This class wraps *cron::instalL* for ease of use
#
# Parameters:
# package_ensure - Can be set to a package version, 'latest', 'installed' or
#  'present'.
#
# default_environment - Allow you to set and environment in one
#  place for all your cron jobs.
#
# job_path - Job install path. Probably will always be default
#  of /etc/cron.d/ but this gives an easy way to test jobs without
#  breaking everything.  Module will raise and error when tidy is
#  enabled and job_path is not /etc/cron.d or /tmp.
#
# job_prefix - Prefix to add to all job files.  This is also used in the
#  glob for tidy cleanup. Will raise an error when tidy is enabled
#  and job_prefix is set to ''.
#
# tidy - Whether or not to enable purge.  Default is false.
#  Will raise and error when enabled and  job_prefix is ''.
#  Module will raise and error when tidy is enabled and
#  job_path is not /etc/cron.d or /tmp.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#   include 'cron'
#
#   class { 'cron':
#     package_ensure => false,
#     tidy           => true,
#     job_prefix     => 'myjobs_',
#   }
#
class cron (
  $package_ensure      = 'installed',
  $default_environment = [],
  $job_path            = '/etc/cron.d',
  $job_prefix          = '',
  $tidy                = false,
) {

  class { '::cron::install': package_ensure => $package_ensure }

  if $tidy {
    if $job_prefix == '' {
      fail('Job prefix must not be blank if you enable tidy on Cron class')
    }
    if $job_path != '/etc/cron.d' and $job_path != '/tmp' {
      fail('Job path must be /etc/cron.d or /tmp if you enable tidy on Cron class')
    }
    tidy { 'puppet-cron-tidy':
      path    => $job_path,
      matches => "${job_prefix}*",
      recurse => true
    }
  }
}
