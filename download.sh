#!/bin/sh
# adjust as desired, the URL scheme should be clear

wget -c http://lt.releases.ubuntu.com/precise/SHA256SUMS -O SHA256SUMS.precise
wget -c http://lt.releases.ubuntu.com/precise/SHA256SUMS.gpg -O SHA256SUMS.precise.gpg
## wget -c http://lt.releases.ubuntu.com/precise/ubuntu-12.04.4-server-amd64.iso
## wget -c http://lt.releases.ubuntu.com/precise/ubuntu-12.04.4-server-i386.iso
## wget -c http://lt.releases.ubuntu.com/precise/ubuntu-12.04.4-desktop-amd64.iso
## wget -c http://lt.releases.ubuntu.com/precise/ubuntu-12.04.4-desktop-i386.iso

wget -c http://lt.releases.ubuntu.com/trusty/SHA256SUMS -O SHA256SUMS.trusty
wget -c http://lt.releases.ubuntu.com/trusty/SHA256SUMS.gpg -O SHA256SUMS.trusty.gpg
## wget -c http://lt.releases.ubuntu.com/trusty/ubuntu-14.04-desktop-amd64.iso
## wget -c http://lt.releases.ubuntu.com/trusty/ubuntu-14.04-server-amd64.iso

## for ubuntu-gnome: http://cdimage.ubuntu.com/ubuntu-gnome/releases/14.10/release/
wget -c http://cdimage.ubuntu.com/ubuntu-gnome/releases/14.10/release/SHA256SUMS -O SHA256SUMS.utopic
wget -c http://cdimage.ubuntu.com/ubuntu-gnome/releases/14.10/release/SHA256SUMS.gpg -O SHA256SUMS.utopic.gpg
## wget -c http://cdimage.ubuntu.com/ubuntu-gnome/releases/14.10/release/ubuntu-gnome-14.10-desktop-amd64.iso
