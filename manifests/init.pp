#
# This class wraps *cron::instalL* for ease of use
#
# Parameters:
# default_environment - Allow you to set and environment in one
#  place for all your cron jobs.
#
# job_path - Job install path. Probably will always be default
#  of /etc/cron.d/ but this gives an easy way to test jobs without
#  breaking everything
#
# job_prefix - Prefix to add to all job files.  This is also used in the
#  glob for tidy cleanup. Will raise an error when tidy is enabled
#  and job_prefix is set to ''.
#
# manage_install - Whether or not to manage package install.
#  Default is true.
#
# tidy - Whether or not to enable purge.  Default is false.
#   Will raise and error when enabled and  job_prefix is ''.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#   include 'cron'
#   class { 'cron':
#     tidy           => true
#     manage_install => false
#     job_prefix     => 'myjobs_'
#   }
class cron (
  $default_environment = [],
  $job_path     = '/etc/cron.d',
  $job_prefix     = '',
  $manage_install = true,
  $tidy           = false,
) {
  if $manage_install {
    include cron::install
  }

  if $tidy {
    if $job_prefix == '' {
      fail('Job prefix must not be blank if you enable tidy on Cron class')
    }
    tidy { 'puppet-cron-tidy':
      path    => $job_path,
      matches => "${job_prefix}*",
      recurse => true
    }
  }
}
