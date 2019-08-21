define named::zone::arecord (
                                $value,
                                $zonename,
                                $record   = $name,
                                $ttl      = undef,
                                $class    = 'IN',
                                $order    = '00',
                                $description = undef,
                                $append_zonename = true,
                              ) {

  concat::fragment{ "A ${record}/${value} record ${named::params::zonedir}/${zonename}":
    target  => "${named::params::zonedir}/${zonename}",
    content => template("${module_name}/zone/arecord.erb"),
    order   => "99-${order}",
  }
}
