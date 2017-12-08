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
  config.vm.box = ENV['BOX']
  config.vm.hostname = ENV['HOST_NAME']
  config.vm.network :forwarded_port, host: ENV['PORT_HOST'], guest: ENV['PORT_GUEST']
  config.vm.synced_folder ENV['WEBROOT_HOST'], ENV['WEBROOT_GUEST'],
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
    vb.name = ENV['VM_NAME']
    vb.memory = ENV['VM_MEMORY']
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
    puppet.facter = {}
    ENV.each do |key, value|
      next unless key =~ /^FACTER_/
      puppet.facter[key.gsub(/^FACTER_/, "")] = value
    end
  end

end
