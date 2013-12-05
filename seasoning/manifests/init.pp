/*
 * This class wraps all classes needed to install the seasoning
 * webapp
 */
class seasoning {
  include seasoning::source
  include seasoning::nginx
  
  include seasoning::environment
  include seasoning::uwsgi
}
