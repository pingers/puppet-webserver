# PHP Configuration file.

define webserver::php::apcu (
  $ensure       = undef,
  $template     = 'webserver/php/apcu.ini.erb',
  $apc_shm_size = '64',
) {
  file { $title:
    ensure  => $ensure,
    content => template($template),
  }
}
