/*
 * This class installs uwsgi
 */
class seasoning::uwsgi {
  require seasoning::environment
  
  python::pip { 'uwsgi==1.9.0':
    virtualenv => '/virtualenvs/Seasoning',
    owner => root,
    install_args => '--use-wheel --no-index --find-links=/tmp/wheels',
    require => Python::Virtualenv['/virtualenvs/Seasoning'],
  }
  
  
}
