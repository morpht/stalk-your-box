# == Manifest: manifest.pp
#
# Installs nagios3, munin and dependencies.
#  
# For Debian based systems.
#
# === Details:
#
# This manifest was created as a simple demo for a presentation at DrupalCon Prague 2013:
#   https://prague2013.drupal.org/session/have-you-been-stalking-your-servers
#
# Tested on Ubuntu 12.04 LTS
#
# === Requires:
#
# Configured MTA. Otherwise, the nagios3 package will install (but probably won't configure the way you would like) postfix.
#
# Please see README.md for other details.
#
# === Authors
#
# Marji Cermak <marji@morpht.com>, http://morpht.com
#


# Execute apt-get update before any package is installed:
exec { 'apt-update':
    command => '/usr/bin/apt-get update',
    # but don't execute it more than once a day:
    unless  => '/usr/bin/test $(find /var/cache/apt/pkgcache.bin -mtime 0 | wc -l ) -eq 1',
}
Exec['apt-update'] -> Package <| |>


# Include minimal apache2 installation. Munin server, nagios and APC dashboard depend on it.
include 'apache2'


# Install munin node and munin server:
class { 'munin::node': }
class { 'munin::server':
  htuser => 'munin',      # Feel free to change. Username for basic access auth.
  htpass => 'Prague2013'  # Feel free to change. Password for basic access auth.
} 

# Install nagios:
class { 'nagios::server':
  contact_email => 'root@localhost', # Feel free to change. Email to send alerts to.
  htpass        => 'Prague2013',     # Feel free to change. Password for the nagiosadmin username.
  # note: the nagiosadmin username is the default which comes with the nagios3 package.
}


# Deployes APC dashboard - install php-apc package and deploy the apc.php script from it.
package { 'php-apc': ensure => installed }
exec { 'deploy-apc-dashboard':
  path    => '/bin:/usr/bin',
  command => 'gzip -dc /usr/share/doc/php-apc/apc.php.gz > /var/www/apc.php', 
  notify  => Service['apache2'],
  unless  => '[ -f /var/www/apc.php ]',
  require => [ Package['php-apc'], Package['apache2'] ]
}

