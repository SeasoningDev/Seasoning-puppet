/*
 * This class installs uwsgi
 */
class seasoning::uwsgi {
  require seasoning::environment
  
  python::pip { 'uwsgi==1.9.20':
    virtualenv => '/virtualenvs/Seasoning',
    owner => root,
    install_args => '--use-wheel --no-index --find-links=/tmp/wheels',
    require => Python::Virtualenv['/virtualenvs/Seasoning'],
  }
  
  user { 'uwsgi':
    ensure => present,
  }
  
  file { 'uwsgi_conf_dir':
    ensure => directory,
    path => '/etc/uwsgi',
    owner => uwsgi,
    group => root,
    mode => 661,
    require => User['uwsgi'],
  }
  
  file { 'uwsgi_config':
    path => '/etc/uwsgi/seasoning.ini',
    owner => uwsgi,
    group => root,
    mode => 661,
    source => 'puppet:///modules/seasoning/uwsgi/seasoning.ini',
    require => File['uwsgi_conf_dir'],
  }
  
  file { 'uwsgi_startup_script':
    path => '/etc/init.d/uwsgi',
    owner => root,
    group => root,
    mode => 755,
    source => 'puppet:///modules/seasoning/uwsgi/uwsgi',
  }
  
  file { 'uwsgi_run_dir':
    ensure => directory,
    path => '/var/run/uwsgi',
    owner => uwsgi,
    group => root,
    mode => 755,
  }
  
  file { 'media_files_dir':
    ensure => directory,
    path => '/srv/media',
    owner => uwsgi,
    group => root,
    mode => 644,
    recurse => true,
  }
  
  service { 'uwsgi':
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => [Python::Pip['uwsgi==1.9.20'], File['uwsgi_config'], File['uwsgi_startup_script']],
    subscribe => [File['uwsgi_config'], File['uwsgi_startup_script']],
  }
  
}
