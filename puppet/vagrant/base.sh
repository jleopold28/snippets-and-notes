#!/bin/sh
systemctl stop firewalld
systemctl disable firewalld

echo "192.168.123.10 puppet.localhost puppet
192.168.123.11 node1.localhost node1
192.168.123.12 node2.localhost node2" >> /etc/hosts

echo "alias sudo='sudo env \"PATH=\$PATH\"'" >> /home/vagrant/.bashrc
