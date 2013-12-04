/**
 * This class install nginx and configures it correctly
 */
class seasoning::nginx {
  
  package { 'seasoning-nginx':
    ensure => installed,
  }
  
  file { 'nginx_conf_dir':
    ensure => directory,
    path => '/usr/local/nginx/conf',
    require => Package['nginx'],
  }
  
  file { 'nginx_init_script':
    path => '/etc/init.d/nginx',
    owner => root,
    group => root,
    mode => 771,
    source => 'puppet:///modules/seasoning/nginx/nginx-init.sh',
    require => Package['nginx'],
  }
  
  file { 'nginx_conf':
    path => '/usr/local/nginx/conf/nginx.conf',
    owner => nginx,
    group => root,
    mode => 661,
    source => 'puppet:///modules/seasoning/nginx/nginx.conf',
    require => File['nginx_conf_dir'],
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
    enabled => true,
    hasrestart => true,
    hasstatus => true,
    require => Package['nginx'],
    subscribe => [File['nginx_init_script'], File['nginx_conf']],
  }
  
}
