# == Class: apache2
#
# A minimalistic module which installs apache2 package and starts the service.
# It tries to do a bare minimum to avoid a possible clash  with an existing apache installation).
#
# For Debian based systems.
#
# === Examples
#
# include apache2
#   or
# class { 'apache2': }
#
# === Authors
#
# Marji Cermak <marji@morpht.com>, http://morpht.com
#
class apache2 {
    
  package { 'apache2': ensure => present }

  service { 'apache2':
    ensure    => running,
  }

}
