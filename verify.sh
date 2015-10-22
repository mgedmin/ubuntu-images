#!/bin/sh
# http://askubuntu.com/a/449483
#VERIFY="gpg --verify"
VERIFY="gpgv --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg"

$VERIFY SHA256SUMS.precise.gpg SHA256SUMS.precise
$VERIFY SHA256SUMS.trusty.gpg SHA256SUMS.trusty
$VERIFY SHA256SUMS.utopic.gpg SHA256SUMS.utopic
$VERIFY SHA256SUMS.vivid.gpg SHA256SUMS.vivid
$VERIFY SHA256SUMS.wily.gpg SHA256SUMS.wily
$VERIFY SHA256SUMS.ubuntu-gnome.wily.gpg SHA256SUMS.ubuntu-gnome.wily

#grep 'desktop\|server' SHA256SUMS.precise | sha256sum -c -
#grep 'amd64' SHA256SUMS.trusty | sha256sum -c -
#grep 'amd64' SHA256SUMS.utopic | sha256sum -c -
#grep 'amd64' SHA256SUMS.vivid | sha256sum -c -
