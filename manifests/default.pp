#!/usr/bin/env ruby

class { 'apache':
  default_vhost => false,
  default_mods => true,
  mpm_module => 'prefork'
}
include apache::mod::php
include apache::mod::rewrite
$aliases = split($vhost_aliases, ' ')
apache::vhost { $aliases[0]:
  port => '80',
  docroot => $vhost_docroot,
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
  directories => [
    {
      path => $vhost_docroot,
      rewrites => [
        {
          rewrite_cond => ['%{REQUEST_FILENAME} !-f'],
          rewrite_rule => ['^(.*)$ /app.php [QSA,L]'],
        }
      ]
    }
  ]
}
apache::vhost { $aliases[1]:
  port => '80',
  docroot => $vhost_docroot,
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
  directories => [
    {
      path => $vhost_docroot,
      rewrites => [
        {
          rewrite_cond => ['%{REQUEST_FILENAME} !-f'],
          rewrite_rule => ['^(.*)$ /app_dev.php [QSA,L]'],
        }
      ]
    }
  ]
}

include php
class { 'php::cli': }
class { 'php::composer':}
include php::extension::curl
include php::extension::gd
include php::extension::mysql
include php::extension::intl
php::config { "date.timezone=$php_timezone":
  file    => '/etc/php5/apache2/php.ini',
  section => 'Date',
}

class { 'mysql::server':
  remove_default_accounts => true
}
mysql::db { $db_name:
  user     => $db_user,
  password => $db_password,
  host     => $db_host,
  grant    => ['ALL'],
}
