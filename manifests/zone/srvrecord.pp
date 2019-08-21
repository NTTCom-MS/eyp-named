#
# _service._proto.name. TTL class SRV priority weight port target.
#
# example:
# _x-puppet._tcp.example.com. IN SRV 0 5 8140 master-b.example.com.
#
# named::zone::srvrecord { 'master-b.example.com.':
#   service => 'puppet',
#   zonename => 'systemadmin.es.',
#   port => '8140',
# }

define named::zone::srvrecord (
                                $service,
                                $port,
                                $zonename,
                                $domain   = undef,
                                $protocol = 'tcp',
                                $target   = $name,
                                $ttl      = undef,
                                $priority = '0',
                                $weight   = '5',
                                $class    = 'IN',
                                $order    = '00',
                                $description = undef,
                              ) {

  concat::fragment{ "srv record ${named::params::zonedir}/${zonename} - ${service} ${port} ${protocol} ${target} ${name} ${ttl} ${priority} ${weight}":
    target  => "${named::params::zonedir}/${zonename}",
    content => template("${module_name}/zone/srvrecord.erb"),
    order   => "99-${order}",
  }
}
