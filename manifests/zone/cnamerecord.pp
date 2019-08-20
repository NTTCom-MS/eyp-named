define named::zone::cnamerecord (
                                $value,
                                $zonename,
                                $record   = $name,
                                $ttl      = undef,
                                $class    = 'IN',
                              ) {

  concat::fragment{ "CNAME ${record}/${value} record ${named::params::zonedir}/${zonename}":
    target  => "${named::params::zonedir}/${zonename}",
    content => template("${module_name}/zone/cnamerecord.erb"),
    order   => '99',
  }
}
