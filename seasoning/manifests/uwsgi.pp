/*
 * This class installs uwsgi
 */
class seasoning::uwsgi {
  require seasoning::environment
  require seasoning::source
  
  exec { "install_uwsgi":
      provider => shell,
      command => "/virtualenvs/Seasoning/bin/pip --log-file /tmp/pip.log install --use-wheel --find-links=/tmp/wheels uwsgi==1.9.20",
      timeout => 1800,
      user => root,
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
  
  file { 'uwsgi_log_dir':
    ensure => directory,
    path => '/var/log/uwsgi',
    owner => uwsgi,
    group => root,
    mode => 755,
  }
  
  service { 'uwsgi':
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    require => [File['uwsgi_config'], File['uwsgi_startup_script']],
    subscribe => [File['uwsgi_config'], File['uwsgi_startup_script']],
  }
  
}
