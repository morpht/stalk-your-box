# == Class: nagios::server
#
# Installs nagios3 package and starts the service.
#  
# For Debian based systems.
#
# === Details:
#
# Depends on class apache2.
# The Web interface will be available at http://12.34.56.78/nagios3/, where 12.34.56.78 is the
# IP address of the server this is being applied on. 
# The htaccess user is "nagiosadmin" (the nagios3 package default), the password can be passed as a parameter.
#
# Tested on Ubuntu 12.04 LTS
#
# === Requires:
#
# Configured MTA. Otherwise, the nagios3 package will install (but probably won't configure the way you would like) postfix.
#
# === Parameters:
#
# [*htpass*]
# The password for the basic authentication.
# The user is 'nagiosadmin', which is the default from the nagios3 package.
#
# [*contact_email*]
# The email addres to send nagios alerts to.
#
# === Examples
#
# include nagios::server
#   or
#  class { 'nagios::server': contact_email => 'root@localhost', htpass => 'Prague2013' }
#
# === Authors
#
# Marji Cermak <marji@morpht.com>, http://morpht.com
#
class nagios::server ( 
    $contact_email = 'root@localhost',
    $htpass        = 'Prague2013'
) {

  include apache2

  package { 'nagios3': ensure => installed }

  file { '/etc/nagios3/conf.d/contacts_nagios2.cfg':
    content => template('nagios/contacts_nagios2.cfg.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nagios3'],
  }

  service { 'nagios3':
    ensure    => running,
    subscribe => File['/etc/nagios3/conf.d/contacts_nagios2.cfg'],
  }

  # Ensure the htpasswd file exists (or create an empty one).
  # This is to prevent overwriting the content (another users) in an existing /etc/nagios3/htpasswd.users file.
  file { '/etc/nagios3/htpasswd.users':
    ensure  => present,
    require => Package['nagios3'],
  }
  # update the existing htpasswd file
  exec { 'update-nagios-htpasswd':
    command   => "/usr/bin/htpasswd -b /etc/nagios3/htpasswd.users nagiosadmin $htpass",
    require   => [ File['/etc/nagios3/htpasswd.users'], Package['apache2'] ],
    logoutput => true,
  }
}
