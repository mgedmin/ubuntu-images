#!/bin/sh
# adjust as desired, the url scheme should be clear
wget -c http://lt.releases.ubuntu.com/precise/SHA256SUMS -o SHA256SUMS.precise
wget -c http://lt.releases.ubuntu.com/precise/SHA256SUMS.gpg -O SHA256SUMS.precise.gpg
wget -c http://lt.releases.ubuntu.com/precise/ubuntu-12.04.4-server-amd64.iso
wget -c http://lt.releases.ubuntu.com/precise/ubuntu-12.04.4-server-i386.iso
wget -c http://lt.releases.ubuntu.com/precise/ubuntu-12.04.4-desktop-amd64.iso
wget -c http://lt.releases.ubuntu.com/precise/ubuntu-12.04.4-desktop-i386.iso
