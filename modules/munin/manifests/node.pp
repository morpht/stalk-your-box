# == Class: munin::node
#
# Installs munin-node package and starts the munin-node service.
# This service needs to run on each node which is monitored.
# For Debian based systems.
#
# === Details:
#
# Tested on Ubuntu 12.04 LTS
#
# === Parameters:
#
# [*munin_server*]
# The IP address of the central munin server (i.e. the grapher/gatherer).
#
# === Examples
#
# include munin::node
#   or
# class { 'munin:node': munin_server => '^12\.34\.56\.78$' }
#
# === Authors
#
# Marji Cermak <marji@morpht.com>, http://morpht.com
#
class munin::node($munin_server = '^127\.0\.0\.1$') {
    
  # $munin_server = '^AAA\.BBB\.CCC\.DDD' - yes, it's a regexp.

  package { 'munin-node': ensure => installed }

  # needed for the MySQL munin plugin:
  package { 'libcache-cache-perl': ensure => installed }

  service { 'munin-node':
    enable    => true,
    ensure    => running,
    hasstatus => true,
    require   => Package["munin-node"],
  }
  file { 'munin-node.conf':
    path    => '/etc/munin/munin-node.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/munin/munin-node.conf",
    require => Package['munin-node'],
    notify  => Service['munin-node'],
  }

}
