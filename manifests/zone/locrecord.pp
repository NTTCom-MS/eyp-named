define named::zone::locrecord (
                                $value,
                                $zonename,
                                $record   = $name,
                                $ttl      = undef,
                                $class    = 'IN',
                              ) {

  concat::fragment{ "LOC ${record}/${value} record ${named::params::zonedir}/${zonename}":
    target  => "${named::params::zonedir}/${zonename}",
    content => template("${module_name}/zone/locrecord.erb"),
    order   => '99',
  }
}
