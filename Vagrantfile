#!/usr/bin/env ruby

def require_plugins(plugins_required)
  to_install = plugins_required.select { |plugins_required| not Vagrant.has_plugin? plugins_required }
  if not to_install.empty?
    puts "Installing plugins: #{to_install.join(' ')}"
    system "vagrant plugin install #{to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  end
end

require_plugins(%w{
  vagrant-aws
  vagrant-env
  vagrant-hostmanager
  vagrant-puppet-install
  vagrant-vbguest
})

Vagrant.configure(2) do |config|
  # use env vars
  config.env.enable

  # config Virtual Machine
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "symfony"
  config.vm.network :forwarded_port, guest: 80, host: 8888
  config.vm.synced_folder "./webroot/web", "/vagrant/webroot/web",
    :owner => "vagrant",
    :group => "www-data",
    :mount_options => ["dmode=775","fmode=775"]

  # configure hosts files
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.aliases = %w(
    app.symfony
    dev.symfony
  )

  # config Virtual Box
  config.vm.provider :virtualbox do |vb|
    vb.name = "Symfony"
    vb.memory = 4096
  end

  # update Puppet
  config.puppet_install.puppet_version = :latest
  
  # load Puppet modules
  config.vm.provision :shell do |shell|
    shell.inline = "gem install --no-rdoc --no-ri librarian-puppet && cd /vagrant && librarian-puppet install"
  end

  # config Puppet
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path =   "manifests"
    puppet.manifest_file =    "site.pp"
    puppet.module_path =      ["modules"]
  end

end
