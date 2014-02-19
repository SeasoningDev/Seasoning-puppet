/*
 * This class wraps all classes needed to install the seasoning
 * webapp
 */
class seasoning {
  
  user { 'uwsgi':
    ensure => present,
  }
  
  include seasoning::source
  
  include seasoning::environment
  include seasoning::uwsgi
  
  include seasoning::nginx

  include seasoning::database
}
