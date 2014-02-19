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
    owner => uwsgi,
    group => root,
    mode => 644,
    recurse => true,
    subscribe => Vcsrepo['/srv/webapps/Seasoning'],
  }
  
  vcsrepo { '/srv/webapps/Seasoning':
    ensure => latest,
    provider => git,
    source => 'git://github.com/SeasoningDev/Seasoning.git',
    revision => 'master',
    require => File['webapps_dir'],
  }
  
  file { 'secrets_file':
    ensure => present,
    path => '/srv/webapps/Seasoning/Seasoning/Seasoning/secrets.py',
    owner => uwsgi,
    group => root,
    mode => 660,
    require => Vcsrepo['/srv/webapps/Seasoning'],
  }

}
