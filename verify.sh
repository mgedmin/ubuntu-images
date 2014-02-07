#!/bin/sh
gpg --verify SHA256SUMS.precise.gpg SHA256SUMS.precise
grep 'desktop\|server' SHA256SUMS.precise | sha256sum -c -
