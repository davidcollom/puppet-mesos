# == Class mesos::repo
#
# This class manages apt repository for Mesos packages
#

class mesos::repo(
  $source = undef
) {

  if $source {
    case $::osfamily {
      'Debian': {
        if !defined(Class['apt']) {
          class { 'apt': }
        }

        $distro = downcase($::operatingsystem)

        case $source {
          undef: {} #nothing to do
          'mesosphere': {
            apt::source { 'mesosphere':
              location    => "http://repos.mesosphere.io/${distro}",
              release     => $::lsbdistcodename,
              repos       => 'main',
              key         => 'E56151BF',
              key_server  => 'keyserver.ubuntu.com',
              include_src => false,
            }
          }
          default: {
            notify { "APT repository '${source}' is not supported for ${::osfamily}": }
          }
        }
      }

      default: {
        fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
      }
    }
  }
}
