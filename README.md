Downloading Ubuntu images
=========================

This is a Makefile that automates the process of downloading Ubuntu ISO images.

Usage:

1. Edit the `Makefile` to pick the images you want to have and the Ubuntu
   mirror you want to use
2. Run `make` to download them
3. Run `make verify-all` to check the file checksums and GPG signatures

There are also Makefile targets to download or verify single files.  Run `make
help` to learn about them.

GPG signature checking assumes you're running on an Ubuntu system, which has
the Ubuntu archive public keys in /usr/share/keyrings/ubuntu-archive-keyring.gpg
