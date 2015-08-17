# The webserver component.

class webserver {

  include php

  $wkhtmltopdf = hiera('wkhtmltopdf', false)
  if $wkhtmltopdf {
    class { 'wkhtmltox':
      ensure => present,
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

  # All other default modules are loaded via
  # apache::default_mods. You can override this array
  # in your hiera definition.
  apache::mod { 'php5':
    package_ensure => 'present',
  }

  # Needed to ensure Include /etc/apache2/conf.d/*.conf
  # doesn't fatally exit
  apache::custom_config { 'placeholder':
    content => '',
  }

  # Ensure php5.conf is loaded (Apache 2.4 seems to want
  # to remove it otherwise - possibly a bug in
  # puppetlabs-apache module?
  file { '/etc/php5/mods-enabled/php5.conf':
    ensure  => link,
    target  => '/etc/apache2/mods-available/php5.conf',
    require => Package['libapache2-mod-php5'],
  }

  $logging = hiera("logging", false)
  if $logging {
    include webserver::logging
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
