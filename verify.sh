#!/bin/sh
#VERIFY="gpg --verify"
VERIFY="gpgv --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg"

#$VERIFY SHA256SUMS.precise.gpg SHA256SUMS.precise
#grep 'desktop\|server' SHA256SUMS.precise | sha256sum -c -

$VERIFY SHA256SUMS.utopic.gpg SHA256SUMS.utopic
grep 'amd64' SHA256SUMS.utopic | sha256sum -c -
