#
# zone concat
# 00 - SOA
# 99 -  srv records
define named::zone(
                    $zonename      = $name,
                    $soa           = $name,
                    $ns            = [ "ns.${name}." ],
                    $mx            = { "mx.${name}." => '5' },
                    $allowtransfer = [],
                    $replace       = true,
                    $notifyslaves  = true,
                    $allowupdate   = [],
                    $alsonotify    = [],
                    $ensure        = 'present',
                    $serial        = '1983120401',
                    $refresh       = '3600',
                    $retry         = '600',
                    $expiry        = '86400',
                    $minttl        = '60',
                    $default_ttl   = '3600',
                    $forwarders    = [],
                    $zonemaster    = undef,
                  ) {

  validate_string($zonename)

  if ($allowupdate)
  {
    validate_array($allowupdate)
  }

  if ($alsonotify)
  {
    validate_array($alsonotify)
  }

  if ($ensure == 'present')
  {
    concat::fragment{ "zone_${zonename}":
      target  => "${named::params::confdir}/puppet-managed.zones",
      content => template("${module_name}/zone.erb")
    }
  }

  concat { "${named::params::zonedir}/${zonename}":
    ensure  => $ensure,
    owner   => 'root',
    group   => $named::params::osuser,
    mode    => '0640',
    replace => $replace,
    notify  => Service[$named::params::servicename],
  }

  concat::fragment{ "base zona ${named::params::zonedir}/${zonename}":
    target  => "${named::params::zonedir}/${zonename}",
    content => template("${module_name}/zonetemplate.erb"),
    order   => '00',
  }


}
