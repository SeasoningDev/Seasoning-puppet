/*
 * This class installs an environment in which the webapp will run
 */
class seasoning::environment {
  require seasoning::source
  
  class { 'python':
    version => '2.7.5',
    pip => true,
    virtualenv => true,
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
    version => '2.7.5',
    owner => root,
    group => root,
    require => File['virtualenvs_dir'],
  }
  
  python::pip { 'uwsgi':
    virtualenv => '/virtualenvs/Seasoning',
    owner => root,
  }
  
  python::requirement { '/srv/webapps/Seasoning/requirements.txt':
    virtualenv => '/virtualenvs/Seasoning',
    owner => root,
  }
  
}
