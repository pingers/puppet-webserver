# A custom PHP class.

class webserver::php (
  # INI.
  $display_errors         = hiera('php_display_errors',         'false'),
  $memory_limit           = hiera('php_memory_limit',           '128M'),
  $post_max_size          = hiera('php_post_max_size',          '20M'),
  $upload_max_filesize    = hiera('php_upload_max_filesize',    '20M'),
  $max_execution_time     = hiera('php_max_execution_time',     '300'),
  $date_timezone          = hiera('php_date_timezone',          'Australia/Adelaide'),
  $error_log              = hiera('php_error_log',              'syslog'),
  $default_socket_timeout = hiera('php_default_socket_timeout', '60'),

  # APC.
  $apc_shm_size        = hiera('php_apc_shm_size',        '64M'),
){

  # Repositories.
  apt::ppa { 'ppa:ondrej/php5-5.6': }
  apt::key { "ondrej": key => "E5267A6C" }

  # Packages.
  package {
    [
      'libapache2-mod-php5',
      'php5-apcu',
      'php5-curl',
      'php5-dev',
      'php5-gd',
      'php5-ldap',
      'php5-mcrypt',
      'php5-memcache',
      'php5-mysql',
      'php5-oauth',
      'php5-sqlite',
      'php5-xdebug'
    ]: ensure => 'installed',
    require => Apt::Ppa['ppa:ondrej/php5-5.6'],
  }

  # Configuration.
  webserver::php::ini { '/etc/php5/apache2/php.ini':
    display_errors         => $display_errors,
    memory_limit           => $memory_limit,
    post_max_size          => $post_max_size,
    upload_max_filesize    => $upload_max_filesize,
    max_execution_time     => $max_execution_time,
    date_timezone          => $date_timezone,
    error_log              => $error_log,
    default_socket_timeout => $default_socket_timeout,
    require                => Package['libapache2-mod-php5'],
  }
  webserver::php::ini { '/etc/php5/cli/php.ini':
    display_errors         => $display_errors,
    memory_limit           => '-1',
    post_max_size          => $post_max_size,
    upload_max_filesize    => $upload_max_filesize,
    max_execution_time     => $max_execution_time,
    date_timezone          => $date_timezone,
    error_log              => $error_log,
    default_socket_timeout => $default_socket_timeout,
    require                => Package['libapache2-mod-php5'],
  }

  webserver::php::apcu { '/etc/php5/apache2/conf.d/20-apcu.ini':
    apc_shm_size => $apc_shm_size,
    require      => Package['php5-apcu'],
  }
  webserver::php::apcu { '/etc/php5/cli/conf.d/20-apcu.ini':
    apc_shm_size => $apc_shm_size,
    require      => Package['php5-apcu'],
  }

}
