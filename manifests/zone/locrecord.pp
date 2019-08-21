define named::zone::locrecord (
                                $value,
                                $zonename,
                                $record          = $name,
                                $ttl             = undef,
                                $class           = 'IN',
                                $order           = '42',
                                $description     = undef,
                                $append_zonename = true,
                              ) {

  concat::fragment{ "LOC ${record}/${value} record ${named::params::zonedir}/${zonename}":
    target  => "${named::params::zonedir}/${zonename}",
    content => template("${module_name}/zone/locrecord.erb"),
    order   => "99-${order}",
  }
}
