/**
 * This class install nginx and configures it correctly
 */
class seasoning::nginx {
  
  file { 'nginx_repo':
    path => '/etc/yum.repos.d/nginx.repo',
    source => 'puppet:///modules/seasoning/nginx/nginx.repo',
  }
  
  package { 'nginx':
    ensure => installed,
    require => File['nginx_repo'], 
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
    require => File['nginx_conf_dir'],
  }
  
  file { 'nginx_ssl_crt':
    path => '/etc/ssl/seasoning.crt',
    owner => nginx,
    group => root,
    mode => 664,
    source => 'puppet:///modules/seasoning/nginx/seasoning.crt',
  }
  
  file { 'nginx_ssl_key':
    ensure => file,
    path => '/etc/ssl/seasoning.key',
    owner => nginx,
    group => root,
    mode => 660,
  }
  
  
  
  file { 'static_files_dir':
    ensure => directory,
    path => '/srv/static',
    owner => root,
    group => root,
    mode => 644,
    recurse => true,
  }
  
  file { 'media_files_dir':
    ensure => directory,
    path => '/srv/media',
    owner => nginx,
    group => root,
    mode => 644,
    recurse => true,
    require => Package['nginx'],
  }
  
  
  
  service { 'nginx':
    ensure => 'running',
    hasrestart => true,
    hasstatus => true,
    require => [Package['nginx'], File['nginx_ssl_crt'], File['nginx_ssl_key']],
    subscribe => File['nginx_conf'],
  }
  
}
