#
# What images we want to download?
#
images :=
## images += ubuntu-12.04.4-desktop-amd64.iso
## images += ubuntu-12.04.4-desktop-i386.iso
## images += ubuntu-12.04.4-server-amd64.iso
## images += ubuntu-12.04.4-server-i386.iso
images += ubuntu-14.04-server-amd64.iso
images += ubuntu-14.04-desktop-amd64.iso
images += ubuntu-gnome-14.04-desktop-amd64.iso
images += ubuntu-15.10-desktop-amd64.iso
images += ubuntu-gnome-15.10-desktop-amd64.iso

#
# What SHA256 sums we want to verify those images?
#
releases := precise trusty wily
ubuntu_gnome_releases := trusty wily
verify := gpgv --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg

sha256sums := \
  $(foreach release,$(releases),SHA256SUMS.${release}) \
  $(foreach release,$(ubuntu_gnome_releases),SHA256SUMS.ubuntu-gnome.${release})

sha256sums_gpg := $(sha256sums:=.gpg)


all: $(sha256sums) $(sha256sums_gpg) $(images)
.PHONY: all

verify: $(foreach fn,$(sha256sums),verify-$(fn))
.PHONY: verify

SHA256SUMS.%:
	wget -c http://lt.releases.ubuntu.com/$*/SHA256SUMS -O $@

SHA256SUMS.%.gpg:
	wget -c http://lt.releases.ubuntu.com/$*/SHA256SUMS.gpg -O $@

SHA256SUMS.ubuntu-gnome.%:
	wget -c http://cdimage.ubuntu.com/ubuntu-gnome/releases/$*/release/SHA256SUMS -O $@

SHA256SUMS.ubuntu-gnome.%.gpg:
	wget -c http://cdimage.ubuntu.com/ubuntu-gnome/releases/$*/release/SHA256SUMS.gpg -O $@

ubuntu-12.04%.iso: ; wget -c http://lt.releases.ubuntu.com/12.04/$@
ubuntu-14.04%.iso: ; wget -c http://lt.releases.ubuntu.com/14.04/$@
ubuntu-15.10%.iso: ; wget -c http://lt.releases.ubuntu.com/15.10/$@

ubuntu-gnome-14.04%.iso: ; wget -c http://cdimage.ubuntu.com/ubuntu-gnome/releases/14.04/release/$@
ubuntu-gnome-15.10%.iso: ; wget -c http://cdimage.ubuntu.com/ubuntu-gnome/releases/15.10/release/$@

verify-SHA256SUMS.%: SHA256SUMS.% SHA256SUMS.%.gpg
	$(verify) SHA256SUMS.$*.gpg SHA256SUMS.$*

