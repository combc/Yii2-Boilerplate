Vagrant.configure("2") do |config|

  config.vm.box = "trusty64"
  config.vm.box_url = "https://atlas.hashicorp.com/chef/boxes/ubuntu-14.04/versions/1.0.0/providers/virtualbox.box"

config.vm.provision "shell" do |s|
    s.path = "core/bootstrap.sh"
    s.args   = [
     #YOUR GITHUB TOKEN HERE
     "",
    #YOUR DATABASE TYPE HERE [mysql|pgsql]
        "mysql"
    ]
end

  config.vm.provider "virtualbox" do |v|
    #v.memory = 512
    #v.cpus = 1
    
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 1080, host: 1081
  config.vm.network "forwarded_port", guest: 1025, host: 1026

  config.vm.provision :shell, inline: 'echo DONE! Thanks ComBC'

end