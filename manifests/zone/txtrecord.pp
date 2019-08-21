define named::zone::txtrecord (
                                $value,
                                $zonename,
                                $record   = $name,
                                $ttl      = undef,
                                $class    = 'IN',
                                $order    = '00',
                                $description = undef,
                                $append_zonename = true,
                              ) {

  concat::fragment{ "TXT ${record}/${value} record ${named::params::zonedir}/${zonename}":
    target  => "${named::params::zonedir}/${zonename}",
    content => template("${module_name}/zone/txtrecord.erb"),
    order   => "99-${order}",
  }
}
