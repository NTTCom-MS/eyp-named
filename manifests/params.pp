class named::params {

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystemrelease
      {
        /^6.*$/:
        {
          $packages= [ 'bind', 'bind-utils' ]
          $confdir='/etc/named'
          $servicename='named'
          $directory='/var/named'

          $zonedir='/var/named'

          $options_file='/etc/named.conf'
          $localconfig_file='/etc/named.conf'

          $osuser='named'

          $managed_keys_dir='/var/named/dynamic'

          $sysconfig_file=undef
          $sysconfig_template=undef
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $packages= [ 'bind9', 'bind9utils', 'dnsutils' ]
              $confdir='/etc/bind'
              $servicename='bind9'
              $directory='/var/cache/bind'

              $zonedir='/etc/bind'

              $options_file='/etc/bind/named.conf.options'
              $localconfig_file='/etc/bind/named.conf.local'

              $osuser='bind'

              $sysconfig_file='/etc/default/bind9'
              $sysconfig_template='debian.erb'
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
