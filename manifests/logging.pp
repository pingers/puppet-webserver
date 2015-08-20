# Logging configuration.

class webserver::logging {

  # Access logs.
  cloudwatchlogs::log { '/var/log/apache2/*access.log':
    group => 'Webserver_Access',
  }

  # Error logs.
  cloudwatchlogs::log { '/var/log/apache2/*error.log':
    group => 'Webserver_Error',
  }

}
