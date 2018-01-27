# WRSC Tracking system

### Install server on VmWare ESX

Hardware:
- Disk 30 GB
- Memory: 4Gb
- CUP: 4 core
- Network: 1 NIC 1GB

Software:
- OS: Ubuntu 1604 LTS x64

- Install Ubuntu
- Update Ubuntu
- Snapshot
- Install ruby on rails:
    - https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-
on-ubuntu-16-04
    - Install ruby 2.1.1
    - Install ruby 2.2.2
    - Take som time
    - Update database:
      - rake db:migrate RAILS_ENV=development

### Static IP

    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).

    source /etc/network/interfaces.d/*

    # The loopback network interface
    auto lo
    iface lo inet loopback# The primary network interface
    auto ens32
    iface ens32 inet static
        address 128.39.115.110
        netmask 255.255.252.0
        network 128.39.112.0
        broadcast 128.39.115.255
        gateway 128.39.112.1
        dns-namesevers 128.39.117.7 128.39.117.9 158.36.138.8 158.36.138.9

### Iptables commands

    sudo iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 8080
    sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A INPUT -p tcp --destination 128.39.115.110/32 --dport 80 -j ACCEPT
    sudo iptables -A INPUT -p tcp --destination 128.39.114.56/32 -j ACCEPT
    sudo iptables -A INPUT -j DROP

### Start the server

Change to folder ~/MYR_rails:

    cd MYR_rails

Start service på port 8080:

    rails server -b 0.0.0.0 -p 8080
