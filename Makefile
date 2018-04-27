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
# What SHA256 sums we want to download so we can verify the images above?
# Look at the URL path components at $(ubuntu_mirror)
#
releases :=
releases += xenial
releases += bionic

verify := gpgv --keyring=/usr/share/keyrings/ubuntu-archive-removed-keys.gpg \
               --keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg

sha256sums := \
  $(foreach release,$(releases),SHA256SUMS.${release})

sha256sums_gpg := $(sha256sums:=.gpg)


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

verify-signatures: verify-sha256sums
.PHONY: verify-signatures

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

ubuntu-16.04%.iso: ; wget -c $(ubuntu_mirror)/16.04/$@
ubuntu-18.04%.iso: ; wget -c $(ubuntu_mirror)/18.04/$@

verify-SHA256SUMS.%: SHA256SUMS.% SHA256SUMS.%.gpg
	$(verify) SHA256SUMS.$*.gpg SHA256SUMS.$*

define verify-recipe =
@grep $(@:verify-%=%) $< | sha256sum -c -
endef

verify-ubuntu-16.04%.iso: SHA256SUMS.xenial  ; $(verify-recipe)
verify-ubuntu-18.04%.iso: SHA256SUMS.bionic  ; $(verify-recipe)

.PRECIOUS: %.iso SHA256SUMS.%
