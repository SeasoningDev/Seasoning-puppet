/**
 * This class sets up the Seasoning database
 */
class seasoning::database {
  include '::mysql::server'
  
  mysql::db { 'seasoning':
    user => 'Seasoning',
    password => 'secret',
    host => localhost
  }
  
}
