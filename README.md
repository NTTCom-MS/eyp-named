# named

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What named affects](#what-named-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with named](#beginning-with-named)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

This module can setup a named daemon and it's zone files

## Module Description

Setup zones as master or slave and configure forwarders and/or if this server can resolve recursively names.

## Setup

### What named affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

This module requires pluginsync enabled

### Beginning with named

To setup as resolver (default):

```puppet
class { 'named': }
```

## Usage

### conditional forwarding

```puppet
class { 'named': }

named::zone { 'systemadmin.es':
  forwarders => [ '8.8.8.8' ]
}
```

### setup as resolver with using a forwarder

```puppet
class { 'named':
	upstreamresolver => [ "8.8.8.8", "8.8.4.4" ],
}
```

### setup a zone using a specific file

```puppet
class { 'named':
	resolver => false,
}

named::zone { 'ccc.local':
	zonename => "ccc.local",
	zonefile => "puppet:///masterdns/ccc.local",
}
```

### setup a zone using it's default template

```puppet
class { 'named':
	resolver => false,
}

named::zone { 'ccc.local':
	zonename => "ccc.local",
}
```

### setup a zone as slave

```puppet
class { 'named':
	resolver => false,
}

named::zone { 'ccc.local':
	zonename => "ccc.local",
	zonemaster => "1.2.3.4",
}
```

### add a server to be notified on every zone change

```puppet
class { 'named':
	alsonotify => [ '192.168.56.15' ],
}
```

### add an additional server to notify for a specific zone

```puppet
named::zone { 'example.local':
  zonefile => 'puppet:///dnsmaster/example.local',
  notifyslaves => true,
  alsonotify => [ '192.168.56.15' ],
}
```

### add a key to allow dynamic updates to a zone

```puppet
named::key { 'kk':
}

named::zone { 'example.local':
 zonename => "example.local",
 zonefile => 'puppet:///dnsmaster/example.local',
 notifyslaves => true,
 replace => false,
 allowtransfer => [ 'any' ],
 allowupdate => [ 'key "kk"' ],
}
```

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Tested on CentOS 6

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
