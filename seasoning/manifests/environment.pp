/*
 * This class installs an environment in which the webapp will run
 */
class seasoning::environment {
  require seasoning::source
  
  file { 'python2.7.rpm': 
    path => '/tmp/python2.7.rpm',
    owner => root,
    group => root,
    source => 'puppet:///modules/seasoning/environment/python27-2.7.6rc1-1.i386.rpm',
  }
  
  package { 'python27-2.7.6rc1-1.i386':
    ensure => installed,
    provider => rpm,
    source => '/tmp/python2.7.rpm',
    require => File['python2.7.rpm'],
  }
  
  file { 'virtualenvs_dir':
    ensure => directory,
    path => '/virtualenvs',
    owner => root,
    group => root,
    mode => 664,
  }
  
  python::virtualenv { '/virtualenvs/Seasoning':
    ensure => present,
    version => '2.7.6',
    path => ['/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
    owner => root,
    group => root,
    require => [Package['python27-2.7.6rc1-1.i386'], File['virtualenvs_dir']],
  }
  
  python::pip { 'uwsgi':
    virtualenv => '/virtualenvs/Seasoning',
    owner => root,
    require => Python::Virtualenv['/virtualenvs/Seasoning'],
  }
  
  python::requirements { '/srv/webapps/Seasoning/requirements.txt':
    virtualenv => '/virtualenvs/Seasoning',
    owner => root,
    require => Python::Virtualenv['/virtualenvs/Seasoning'],
  }
  
}
