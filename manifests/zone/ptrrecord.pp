define named::zone::ptrrecord (
                                $value,
                                $zonename,
                                $record          = $name,
                                $ttl             = undef,
                                $class           = 'IN',
                                $order           = '42',
                                $description     = undef,
                                $append_zonename = true,
                              ) {

  concat::fragment{ "PTR ${record}/${value} record ${named::params::zonedir}/${zonename}":
    target  => "${named::params::zonedir}/${zonename}",
    content => template("${module_name}/zone/ptrrecord.erb"),
    order   => "99-${order}",
  }
}
