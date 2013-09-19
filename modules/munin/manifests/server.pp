# == Class: munin::server
#
# Installs munin. 
# For Debian based systems.
#
# === Details:
# Depends on class apache2.
# The Web interface will be available at http://12.34.56.78/nagios3/, where 12.34.56.78 is the
# IP address of the server this is being applied on. 
# The htaccess user and password can be passed as parameters.
#
# It installs basic authentication.
#
# Tested on Ubuntu 12.04 LTS
#
# === Parameters:
#
# [*htuser*]
#
# [*htpass*]
#
# === Examples
#
# include munin::server
#   or
# class { 'munin:server': htuser => 'user', htpass => 'letmein' }
#
# === Authors
#
# Marji Cermak <marji@morpht.com>, http://morpht.com
#
class munin::server ( 
    $htuser = 'Munin',
    $htpass = 'Prague2013'
) {
    
  include apache2

  package { 'munin': ensure => installed }


  file { '/etc/apache2/conf.d/munin':
    ensure  => link,
    target  => '/etc/munin/apache.conf',
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  file { '/etc/munin/apache.conf':
    content => template('munin/apache.conf.erb'),
    require => Package['munin'],
  }

  # Ensure the htpasswd file exists (or create an empty one).
  # This is to prevent overwriting the content (another users) in an existing /etc/munin/munin-htpasswd file.
  file { '/etc/munin/munin-htpasswd':
    ensure  => present,
    require => Package['munin'],
  }
  # update the existing htpasswd file
  exec { 'update-munin-htpasswd':
    command   => "/usr/bin/htpasswd -b /etc/munin/munin-htpasswd $htuser $htpass",
    require   => [ File['/etc/munin/munin-htpasswd'], Package['apache2'] ],
    logoutput => true,
  }
}
