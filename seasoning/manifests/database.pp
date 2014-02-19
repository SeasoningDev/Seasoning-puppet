/**
 * This class sets up the Seasoning database
 */
class seasoning::database {
  include '::mysql::server'
  
  mysql::db { 'seasoning':
    user => 'Seasoning',
    password => $db_pw,
    host => localhost
  }
  
  file { 'mysql_backups_dir':
    ensure => directory,
    path => '/backups/mysql',
  } 
}
