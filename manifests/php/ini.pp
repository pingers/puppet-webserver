# PHP Configuration file.

define webserver::php::ini (
  $ensure                 = undef,
  $template               = 'webserver/php/php.ini.erb',
  $display_errors         = false,
  $memory_limit           = '128M',
  $post_max_size          = '20M',
  $upload_max_filesize    = '20M',
  $max_execution_time     = '300',
  $date_timezone          = 'Australia/Adelaide',
  $error_log              = 'syslog',
  $default_socket_timeout = '60',
) {
  file { $title:
    ensure  => $ensure,
    content => template($template),
  }
}
