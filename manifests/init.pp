class named (
              $upstreamresolver = undef,
              $resolver         = true,
              $keysdir          = "${named::params::confdir}/keys",
              $alsonotify       = undef,
              $dnssecenable     = 'no',
              $dnssecvalidation = 'no',
              $controls         = undef, #TODO: rewrite
              $ensure           = 'installed',
              $ipv6             = false,
            ) inherits named::params {

  if ($upstreamresolver) {
    validate_array($upstreamresolver)
  }

  validate_bool($resolver)

  if ($alsonotify)
  {
    validate_array($alsonotify)
  }

  if ($controls)
  {
    validate_array($controls)
  }

  validate_re($ensure, [ '^installed$', '^latest$' ], "Not a valid package status: ${ensure}")

  if defined(Class['netbackupclient'])
  {
    netbackupclient::includedir{ '/var/named': }

  }

  #deprecated, crec
  #include concat::setup

  package { $named::params::packages:
    ensure => $ensure,
  }

  if($named::params::sysconfig_file!=undef)
  {
    file { $named::params::sysconfig_file:
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/sysconfig/${named::params::sysconfig_template}"),
      require => Package[$named::params::packages],
      notify  => Service[$named::params::servicename],
      before  => Service[$named::params::servicename],
    }
  }

  file { $keysdir:
    ensure  => 'directory',
    owner   => 'root',
    group   => $named::params::osuser,
    mode    => '0750',
    require => Package[$named::params::packages],
  }

  $keysdishelpers="${keysdir}/.helpers"
  file { $keysdishelpers:
    ensure  => 'directory',
    owner   => 'root',
    group   => $named::params::osuser,
    mode    => '0750',
    require => File[$keysdir],
  }

  concat { $named::params::options_file:
    ensure  => 'present',
    owner   => 'root',
    group   => $named::params::osuser,
    mode    => '0640',
    require => Package[$named::params::packages],
    notify  => Service[$named::params::servicename],
  }

  if($named::params::localconfig_file==$named::params::options_file)
  {
    concat::fragment{ "${named::params::options_file} tail":
      target  => $named::params::options_file,
      content => template("${module_name}/namedRH.erb"),
      order   => '99',
    }

  }
  else
  {
    concat { $named::params::localconfig_file:
      ensure  => 'present',
      owner   => 'root',
      group   => $named::params::osuser,
      mode    => '0640',
      require => Package[$named::params::packages],
      notify  => Service[$named::params::servicename],
    }

    concat::fragment{ "${named::params::localconfig_file} header":
      target  => $named::params::localconfig_file,
      content => "//\n// Puppet managed - do not edit\n//\n\n",
      order   => '01',
    }

  }

  concat::fragment{ "${named::params::localconfig_file} localconf content":
    target  => $named::params::localconfig_file,
    content => template("${module_name}/namedlocalconf.erb"),
    order   => '50',
  }

  concat::fragment{ "${named::params::options_file} header":
    target  => $named::params::options_file,
    content => "//\n// Puppet managed - do not edit\n//\n\n",
    order   => '01'
  }

  concat::fragment{ "${named::params::options_file} options content":
    target  => $named::params::options_file,
    content => template("${module_name}/namedoptions.erb"),
    order   => '02'
  }



  file { $named::params::directory:
    ensure  => 'directory',
    owner   => 'root',
    group   => $named::params::osuser,
    mode    => '0770',
    require => Package[$named::params::packages],
  }

  file { "${named::params::directory}/data":
    ensure  => 'directory',
    owner   => $named::params::osuser,
    group   => $named::params::osuser,
    mode    => '0770',
    require => File[$named::params::directory],
  }

  file { $named::params::confdir:
    ensure  => 'directory',
    owner   => 'root',
    group   => $named::params::osuser,
    mode    => '0770',
    require => File[ [$named::params::directory, "${named::params::directory}/data" ] ],
  }

  concat { "${named::params::confdir}/puppet-managed.zones":
    ensure  => 'present',
    owner   => 'root',
    group   => $named::params::osuser,
    mode    => '0640',
    require => File[$named::params::confdir],
    notify  => Service[$named::params::servicename],
  }

  concat { "${named::params::confdir}/puppet-managed.keys":
    ensure  => 'present',
    owner   => 'root',
    group   => $named::params::osuser,
    mode    => '0640',
    require => File[$named::params::confdir],
    notify  => Service[$named::params::servicename],
  }

  concat::fragment{ 'puppet_header_zones':
    target  => "${named::params::confdir}/puppet-managed.zones",
    content => "//\n// Puppet managed - do not edit\n//\n\n",
    order   => '01'
  }

  concat::fragment{ 'puppet_header_keys':
    target  => "${named::params::confdir}/puppet-managed.keys",
    content => "//\n// Puppet managed - do not edit\n//\n\n",
    order   => '01'
  }

  service { $named::params::servicename:
    ensure  => 'running',
    enable  => true,
    require => Concat["${named::params::confdir}/puppet-managed.zones"],
  }

}
