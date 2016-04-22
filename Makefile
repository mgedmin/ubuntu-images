#
# What images we want to download?
#
images :=
## images += ubuntu-12.04.4-desktop-amd64.iso
## images += ubuntu-12.04.4-desktop-i386.iso
## images += ubuntu-12.04.4-server-amd64.iso
## images += ubuntu-12.04.4-server-i386.iso
## images += ubuntu-14.04-server-amd64.iso
## images += ubuntu-14.04-desktop-amd64.iso
## images += ubuntu-gnome-14.04-desktop-amd64.iso
## images += ubuntu-15.10-desktop-amd64.iso
## images += ubuntu-gnome-15.10-desktop-amd64.iso
images += ubuntu-16.04-server-amd64.iso
images += ubuntu-16.04-desktop-amd64.iso
images += ubuntu-gnome-16.04-desktop-amd64.iso

#
# What SHA256 sums we want to download so we can verify the images above?
#
releases :=
## releases += precise
## releases += trusty
## releases += wily
releases += xenial

ubuntu_gnome_releases :=
## ubuntu_gnome_releases += trusty
## ubuntu_gnome_releases += wily
ubuntu_gnome_releases := xenial

ubuntu_mirror := http://lt.releases.ubuntu.com
ubuntu_gnome_mirror := http://cdimage.ubuntu.com/ubuntu-gnome/releases

verify := gpgv --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg

sha256sums := \
  $(foreach release,$(releases),SHA256SUMS.${release}) \
  $(foreach release,$(ubuntu_gnome_releases),SHA256SUMS.ubuntu-gnome.${release})

sha256sums_gpg := $(sha256sums:=.gpg)


all: $(sha256sums) $(sha256sums_gpg) $(images)
.PHONY: all

help:
	@echo "make all                     -- download all ISO images"
	@echo "make <filename>.iso          -- download one ISO image"
	@echo "make verify-sha256sums       -- verify GPG signatures of all SHA256SUMS files"
	@echo "make verify-SHA256SUMS.<ver> -- verify SHA256 checksums of one SHA256SUMS file"
	@echo "make verify-images           -- verify SHA256 checksums of all ISO images"
	@echo "make verify-<filename>.iso   -- verify SHA256 checksums of one ISO image"
	@echo "make verify-all              -- verify all of the above"
	@echo
	@echo "Default set of images:"
	@printf "  %s\n" $(images)
.PHONY: help

verify-sha256sums: $(foreach fn,$(sha256sums),verify-$(fn))
.PHONY: verify-sha256sums

verify-images: $(foreach fn,$(images),verify-$(fn))
.PHONY: verify-images

verify-all: verify-sha256sums verify-images
.PHONY: verify-all

SHA256SUMS.%:
	wget -c $(ubuntu_mirror)/$*/SHA256SUMS -O $@

SHA256SUMS.%.gpg:
	wget -c $(ubuntu_mirror)/$*/SHA256SUMS.gpg -O $@

SHA256SUMS.ubuntu-gnome.%:
	wget -c $(ubuntu_gnome_mirror)/$*/release/SHA256SUMS -O $@

SHA256SUMS.ubuntu-gnome.%.gpg:
	wget -c $(ubuntu_gnome_mirror)/$*/release/SHA256SUMS.gpg -O $@

ubuntu-12.04%.iso: ; wget -c $(ubuntu_mirror)/12.04/$@
ubuntu-14.04%.iso: ; wget -c $(ubuntu_mirror)/14.04/$@
ubuntu-15.10%.iso: ; wget -c $(ubuntu_mirror)/15.10/$@
ubuntu-16.04%.iso: ; wget -c $(ubuntu_mirror)/16.04/$@

ubuntu-gnome-14.04%.iso: ; wget -c $(ubuntu_gnome_mirror)/14.04/release/$@
ubuntu-gnome-15.10%.iso: ; wget -c $(ubuntu_gnome_mirror)/15.10/release/$@
ubuntu-gnome-16.04%.iso: ; wget -c $(ubuntu_gnome_mirror)/16.04/release/$@

verify-SHA256SUMS.%: SHA256SUMS.% SHA256SUMS.%.gpg
	$(verify) SHA256SUMS.$*.gpg SHA256SUMS.$*

define verify-recipe =
@grep $(@:verify-%=%) $< | sha256sum -c -
endef

verify-ubuntu-12.04%.iso: SHA256SUMS.precise ; $(verify-recipe)
verify-ubuntu-14.04%.iso: SHA256SUMS.trusty  ; $(verify-recipe)
verify-ubuntu-15.10%.iso: SHA256SUMS.wily    ; $(verify-recipe)
verify-ubuntu-16.04%.iso: SHA256SUMS.xenial  ; $(verify-recipe)
verify-ubuntu-gnome-14.04%.iso: SHA256SUMS.ubuntu-gnome.trusty ; $(verify-recipe)
verify-ubuntu-gnome-15.10%.iso: SHA256SUMS.ubuntu-gnome.wily   ; $(verify-recipe)
verify-ubuntu-gnome-16.04%.iso: SHA256SUMS.ubuntu-gnome.xenial ; $(verify-recipe)
