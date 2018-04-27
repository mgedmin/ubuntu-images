#
# The Ubuntu mirror we want to use.
# Usually it's http://<country-code>.releases.ubuntu.com
#

ubuntu_mirror := http://lt.releases.ubuntu.com

#
# What images we want to download?
# Look up the filenames at $(ubuntu_mirror)
#

images :=
images += ubuntu-16.04.4-server-amd64.iso
images += ubuntu-18.04-desktop-amd64.iso
images += ubuntu-18.04-live-server-amd64.iso

#
# Where are the keyrings located that contain trusted repository GPG keys?
#

verify := gpgv --keyring=/usr/share/keyrings/ubuntu-archive-removed-keys.gpg \
               --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg

#
# Implementation: helper functions
#

# $(call split,16.04.4-desktop-amd64.iso,-) -> 16.04.4 desktop amd64.iso
# $(call majver,16.04.4) -> 16.04
# $(call release,16.04.4-desktop-amd64.iso) -> 16.04
split = $(subst $2, ,$1)
majver = $(firstword $(call split,$1,.)).$(word 2,$(call split,$1,.))
release = $(call majver,$(firstword $(call split,$1,-)))

# Compute Ubuntu releases and SHA256SUMS files

releases := $(foreach fn,$(images),$(call release,$(fn:ubuntu-%=%)))
sha256sums := $(foreach release,$(releases),SHA256SUMS.$(release))
sha256sums_gpg := $(sha256sums:=.gpg)

#
# Rules
#

all: $(sha256sums) $(sha256sums_gpg) $(images)
.PHONY: all

help:
	@echo "make all                     -- download all ISO images"
	@echo "make <filename>.iso          -- download one ISO image"
	@echo "make download-signatures     -- download all SHA256SUMS files"
	@echo "make verify-sha256sums       -- verify GPG signatures of all SHA256SUMS files"
	@echo "make verify-SHA256SUMS.<ver> -- verify SHA256 checksums of one SHA256SUMS file"
	@echo "make verify-images           -- verify SHA256 checksums of all ISO images"
	@echo "make verify-<filename>.iso   -- verify SHA256 checksums of one ISO image"
	@echo "make verify-all              -- verify all of the above"
	@echo
	@echo "Default set of images:"
	@printf "  %s\n" $(images)
.PHONY: help

download-signatures: $(sha256sums) $(sha256sums_gpg)
.PHONY: download-signatures

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

ubuntu-%.iso:
	wget -c $(ubuntu_mirror)/$(call release,$*)/$@

verify-SHA256SUMS.%: SHA256SUMS.% SHA256SUMS.%.gpg
	$(verify) SHA256SUMS.$*.gpg SHA256SUMS.$*

.SECONDEXPANSION:
verify-ubuntu-%.iso: SHA256SUMS.$$(call release,$$*)
	@grep $(@:verify-%=%) $< | sha256sum -c -

.PRECIOUS: %.iso SHA256SUMS.%
