/*
 * This class downloads the seasoning source code
 */
class seasoning::source {
  
  file { 'webapps_dir':
    ensure => directory,
    path => '/srv/webapps',
  }
  
  file { 'source_dir':
    ensure => directory,
    path => '/srv/webapps/Seasoning',
    owner => root,
    group => root,
    mode => 644,
    recurse => true,
    require => File['webapps_dir'],
  }
  
  vcsrepo { '/srv/webapps/Seasoning':
    ensure => present,
    provider => git,
    source => 'git://github.com/SeasoningDev/Seasoning.git',
    revision => 'master',
    require => File['source_dir'],
  }
  
  file { 'secrets_file':
    ensure => present,
    path => '/srv/webapps/Seasoning/Seasoning/Seasoning/secrets.py',
    owner => root,
    group => root,
    mode => 660,
    content => template('seasoning/source/secrets.py.erb'),
    require => Vcsrepo['/srv/webapps/Seasoning'],
  }  
  
}
