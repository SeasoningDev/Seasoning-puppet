/**
 * This class install nginx and configures it correctly
 */
class seasoning::nginx {
  require seasoning::uwsgi
  
  file { 'nginx_repo':
    path => '/etc/yum.repos.d/nginx.repo',
    source => 'puppet:///modules/seasoning/nginx/nginx.repo',
  }
  
  package { 'httpd':
    ensure => absent,
  }

  package { 'nginx':
    ensure => installed,
    require => [Package['httpd'], File['nginx_repo']], 
  }

  file { 'nginx_sysconfig':
    path => '/etc/sysconfig/nginx',
    source => 'puppet:///modules/seasoning/nginx/nginx_sysconfig',
    require => Package['nginx'],
  }
  
  file { 'nginx_conf_dir':
    ensure => directory,
    path => '/etc/nginx/conf.d',
    require => Package['nginx'],
  }
  
  file { 'nginx_conf':
    path => '/etc/nginx/conf.d/seasoning.conf',
    owner => nginx,
    group => root,
    mode => 661,
    source => 'puppet:///modules/seasoning/nginx/seasoning.conf',
    require => [File['nginx_conf_dir'], Package['nginx'], ],
  }

  file { 'nginx_uwsgi_params':
    path => '/etc/nginx/conf.d/uwsgi_params',
    owner => nginx,
    group => root,
    mode => 661,
    source => 'puppet:///modules/seasoning/nginx/uwsgi_params',
    require => [File['nginx_conf_dir'], Package['nginx'], ],
  }
  
  file { 'nginx_ssl_crt':
    path => '/etc/ssl/seasoning.crt',
    owner => nginx,
    group => root,
    mode => 664,
    source => 'puppet:///modules/seasoning/nginx/seasoning.crt',
    require => Package['nginx'],
  }
  
  file { 'nginx_ssl_key':
    ensure => file,
    path => '/etc/ssl/seasoning.key',
    owner => nginx,
    group => root,
    mode => 660,
    require => Package['nginx'],
  }
  
  file { 'media_files_dir':
    ensure => directory,
    path => '/srv/media',
    owner => uwsgi,
    group => root,
    mode => 644,
    recurse => true,
  }  
  
  file { 'static_files_dir':
    ensure => directory,
    path => '/srv/static',
    owner => uwsgi,
    group => root,
    mode => 644,
    recurse => true,
  }
  
  service { 'nginx':
    ensure => 'running',
    hasrestart => true,
    hasstatus => true,
    require => [Package['nginx'], File['nginx_sysconfig'], File['nginx_ssl_crt'], File['nginx_ssl_key']],
    subscribe => [File['nginx_sysconfig'], File['nginx_conf'], ],
  }
  
}
