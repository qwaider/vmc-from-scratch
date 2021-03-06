import "install-zeromq.pp"
import "install-jzmq.pp"


class install-storm () {

  $stormV = 'apache-storm-0.9.3'

  $user = 'newsreader'
  $group = 'newsreader'

  include install-zeromq
  include install-jzmq
  
  group { 'storm-group':
    ensure => present,
    name => $group,
  }

  user { 'storm-user':
    ensure => present,
    name => $user,
    gid => $group,
    home => "/home/$user",
    managehome => true,
    shell => '/bin/bash',
    require => Group['storm-group'],
  }

  package { 'unzip-install':
    name => 'unzip',
    ensure => installed,
  }

  wget { 'download-storm':
    url => "http://ixa2.si.ehu.es/newsreader_storm_resources/${stormV}.zip",
    creates => "/tmp/${stormV}.zip",
    require => Package['unzip-install'],
  }      
  
  exec { 'unzip':
    command => "/usr/bin/unzip /tmp/${stormV}.zip -d /opt",
    require => Wget['download-storm'],
    creates => "/opt/${stormV}",
  }

  file { 'storm-chown':
    ensure => directory,
    name => "/opt/${stormV}",
    owner => $user,
    group => $group,
    recurse => true,
    require => Exec['unzip'], 
  }

  file { 'storm-symlnk':
    ensure => link,
    name => '/opt/storm',
    target => "/opt/${stormV}",
    owner => $user,
    group => $group,
    require => File['storm-chown'],
  }

  file { 'storm-data-dir':
    ensure => directory,
    name => '/var/lib/storm',
    owner => $user,
    group => $group,
  }

  file { 'storm-log-dir':
    ensure => directory,
    name => '/var/log/storm',
    owner => $user,
    group => $group,
  }

  file { 'storm-conf':
    ensure => file,
    name => '/opt/storm/conf/storm.yaml',
    owner => $user,
    group => $group,
    source => 'puppet:///conf_files/storm.conf',
  }
  
}
