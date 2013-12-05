/*
 * This class installs an environment in which the webapp will run
 */
class seasoning::environment {
  require seasoning::source
  
  file { 'python2.7.rpm': 
    path => '/tmp/python2.7.rpm',
    owner => root,
    group => root,
    source => "puppet:///modules/seasoning/environment/${architecture}/python27-2.7.6rc1-1.${architecture}.rpm",
  }
  
  package { "python27-2.7.6rc1-1.${architecture}":
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
    version => '2.7',
    path => ['/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
    owner => root,
    group => root,
    require => [Package["python27-2.7.6rc1-1.${architecture}"], File['virtualenvs_dir']],
  }
  
  file { 'seasoning_requirements':
    path => '/srv/webapps/Seasoning/requirements.txt',
    ensure => present,
    replace => false,
  }
  
  file { 'wheels':
    path => '/tmp/wheels',
    source => "puppet:///modules/seasoning/environment/${architecture}/wheels",
    recurse => true,
  }
  
  exec { "seasoning_requirements":
    provider => shell,
    command => "'/virtualenvs/Seasoning/bin/pip --log-file ${cwd}/pip.log install --use-wheel --no-index --find-links=/tmp/wheels -r /srv/webapps/Seasoning/requirements.txt",
    refreshonly => true,
    timeout => 1800,
    user => root,
    subscribe => File[seasoning_requirements],
  }
  
  python::pip { 'uwsgi':
    virtualenv => '/virtualenvs/Seasoning',
    owner => root,
    install_args => '--use-wheel --no-index --find-links=/tmp/wheels',
    require => Python::Virtualenv['/virtualenvs/Seasoning'],
  }
  
}
