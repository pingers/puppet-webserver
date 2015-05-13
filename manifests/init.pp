# The webserver component.

class webserver {

  include php

  $wkhtmltopdf = hiera('wkhtmltopdf', false)
  if wkhtmltopdf {
    package { 'wkhtmltopdf':
      ensure => present
    }
  }

  class { 'apache':
    default_vhost => false,
    mpm_module    => 'prefork',
    manage_user   => false,
    manage_group  => false,
  }

  class { 'composer':
    command_name => 'composer',
    target_dir   => '/usr/local/bin',
  }

  class { 'memcached':
    max_memory => 128,
  }

  apache::mod { [
    'php5',
    'rewrite',
    'actions',
    'headers',
  ]:
    package_ensure => 'present',
  }

  ##
  # Hiera.
  ##

  $apache_vhosts = hiera_hash('apache_vhosts', false)
  if $apache_vhosts {
    create_resources(apache::vhost, $apache_vhosts)
  }

  $apache_mods = hiera_hash('apache_mods', false)
  if $apache_mods {
    create_resources(apache::mod, $apache_mods)
  }

}
