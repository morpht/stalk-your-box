# Stalk Your Box

This manifest was created as part of a simple demo for our presentation at DrupalCon Prague 2013:
  https://prague2013.drupal.org/session/have-you-been-stalking-your-servers

It installs Munin and Nagios on your server and protects them with Basic access authentication.

## Description
A small Puppet manifest to get you started with monitoring your dev LAMP server.
It's meant to be applied on the LAMP server, so your server will become the monitoring and the monitored server.
Indeed, these two roles are better to split in a production environment, but even if they are on the same server, you can still get an email *before* bad things happen (e.g. before your root filesystem fills out) or you can analyse the graphs after a crash to see what had been actually happening before it crashed.

Currently for Ubuntu 12.04 LTS (but likely to work on newer versions and other Debian based distributions).

## Used components
-    nagios3
-    munin, munin-node

## Requires
The box provisioned with this manifest needs to be able to deliver emails, at least to the nagios contact email address
(which is up to you to choose - it's a parameter of the nagios3 module).
The nagios3 package installs postfix as the default MTA (if none is instaled) as a dependency, but it probably won't get configured the way you would like. 

Apache2. Ideally, you will have a functional LAMP stack installed before applying this. Apache2 is required by both munin and nagios.
If not installed, it will get installed (as the manifest requires the apache2 package. The libapache2-mod-php5 package will also get installed as the munin package dependency if no other php [e.g. php5-fpm] is installed).


## Usage
Go to the VM or server you want to provision and run the following commands.

If you don't have puppet installed, install it first:
```
sudo apt-get update && sudo apt-get --yes install puppet
```

If you don't have git installed, install it:
```
sudo apt-get update && sudo apt-get --yes install git
```

Get the repo: 
```
git clone git://github.com/morpht/stalk-your-box.git /tmp/stalk-your-box
sudo mv /tmp/stalk-your-box /opt/stalk-your-box
```
**Recommended:** edit or review the `/opt/stalk-your-box/manifest.pp` in your favourite editor - you might want to change the email address for nagios alerts, the Basic access authentication or perhaps comment out the nagios or munin classes to prevent one of these two components to install.

Then run puppet apply:  
```
sudo puppet apply --modulepath=/opt/stalk-your-box/modules /opt/stalk-your-box/manifest.pp
```

The Web interface will be available at http://12.34.56.78/nagios3/ and http://12.34.56.78/munin/, where 12.34.56.78 is the IP address of the server this manifest is applied on. 

It might take at least 15 minutes before you will be able to see *some* values in the Munin graphs.

### Basic access authentication
The manifest deployes basic authentication with these defaults:
-   The Munin app:  `munin:Prague2013`
-   The Nagios app: `nagiosadmin:Prague2013`

Please change the credentials in `/opt/stalk-your-box/manifest.pp` anytime and run `puppet apply`.

## Notes
-   If your dev server is in a home network and you don't get any emails, it might be that some providers block outgoing port 25.

-   If you have mysql installed **before** applying this manifest, you will get up to 23 MySQL related graphs automatically generated by Munin.


## Author
Marji Cermak <marji@morpht.com>, http://morpht.com