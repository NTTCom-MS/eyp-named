# == Define: named::key
#
# named::key
#
# === Parameters
#
#
# [*keyname*]
#   Specify keyname, default's to resource's name
#
#
# === Examples
#
# #add a key to allow dynamic updates to a zone
#	named::key { 'kk':
#	}
#
#	named::zone { 'example.local':
#		zonename => "example.local",
#		zonefile => 'puppet:///dnsmaster/example.local',
#		notifyslaves => true,
#		replace => false,
#		allowtransfer => [ 'any' ],
#		allowupdate => [ 'key "kk"' ],
#	}
#
#
#
# === Authors
#
# Jordi Prats <jordi.prats@gmail.com>
#
# === Copyright
#
# Copyright 2015 Jordi Prats, unless otherwise noted.
#
define named::key ($keyname=$name) {

	validate_string($keyname)

	file { "${named::keysdir}/.helpers/initkeyconf.${keyname}":
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode    => '0640',
		content => template("${module_name}/initkeyconf.erb"),
	}

	#dnssec-keygen -r /dev/urandom -a HMAC-MD5 -b 512 -n HOST -K /etc/named/keys/ test > /etc/named/keys/keygen.log 2>&1

	exec { "dynupdateskeygen_${keyname}":
   	command => "/usr/sbin/dnssec-keygen -r /dev/urandom -a HMAC-MD5 -b 512 -n HOST -K ${named::keysdir}/ ${keyname} > ${named::keysdir}/keygen.${keyname}.log 2>&1",
		creates => "${named::keysdir}/keygen.${keyname}.log",
		require => File["${named::keysdir}/.helpers/initkeyconf.${keyname}"]
	}

	exec { "generate_keyfile_${keyname}":
		command => "/bin/bash ${named::keysdir}/.helpers/initkeyconf.${keyname} > ${named::keysdir}/${keyname}.conf",
		creates => "${named::keysdir}/${keyname}.conf",
		require => Exec["dynupdateskeygen_${keyname}"],
	}

	concat::fragment{ "keyfile_include_${keyname}":
		target  => "${named::params::confdir}/puppet-managed.keys",
		content => "include \"${named::keysdir}/${keyname}.conf\";\n\n",
		require => Exec["generate_keyfile_${keyname}"],
	}

}
