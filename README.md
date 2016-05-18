# named

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with named](#setup)
    * [What named affects](#what-named-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with named](#beginning-with-named)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

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

To setup as resolver with using a forwarder:

```puppet
class { 'named':
	$upstreamresolver => [ "8.8.8.8", "8.8.4.4" ],
}
```

To setup a zone using a specific file:

```puppet
	class { 'named':
		resolver => false,
	}

	named::zone { 'ccc.local':
		zonename => "ccc.local",
		zonefile => "puppet:///masterdns/ccc.local",
	}
```

To setup a zone using it's default template

```puppet
	class { 'named':
		resolver => false,
	}

	named::zone { 'ccc.local':
		zonename => "ccc.local",
	}
```

To setup a zone as slave:

```puppet
	class { 'named':
		resolver => false,
	}

	named::zone { 'ccc.local':
		zonename => "ccc.local",
		zonemaster => "1.2.3.4",
	}
```

Add a server to be notified on every zone change

```puppet
	class { 'named':
		alsonotify => [ '192.168.56.15' ],
	}
```

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Tested in CentOS 6

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
