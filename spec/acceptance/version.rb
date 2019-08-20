
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $packagename  = 'bind'
  $servicename  = 'named'

when 'Debian'
  $packagename = 'bind9'
  $servicename = 'bind9'

else
  $packagename = '-_-'
  $servicename = '-_-'

end
