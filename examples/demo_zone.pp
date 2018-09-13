class { 'named': }

named::zone { 'systemadmin.es':
  forwarders => [ '8.8.8.8' ]
}
