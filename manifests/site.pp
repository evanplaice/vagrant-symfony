#!/usr/bin/env ruby

class { 'apache':
  default_vhost => false,
  default_mods => true,
  mpm_module => 'prefork'
}
include apache::mod::php
include apache::mod::rewrite
apache::vhost { 'app.symfony':
  port => '80',
  docroot => '/vagrant/webroot/web',
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
  directories => [
    {
      path => '/vagrant/webroot/web',
      rewrites => [
        {
          rewrite_cond => ['%{REQUEST_FILENAME} !-f'],
          rewrite_rule => ['^(.*)$ /app.php [QSA,L]'],
        }
      ]
    }
  ]
}
apache::vhost { 'dev.symfony':
  port => '80',
  docroot => '/vagrant/webroot/web',
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
  directories => [
    {
      path => '/vagrant/webroot/web',
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

class { 'mysql::server':
  root_password => 'qwe123',
}
