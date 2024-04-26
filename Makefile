#
# The Ubuntu mirror we want to use.
# Usually it's http://<country-code>.releases.ubuntu.com
#

# for some reason the LT mirror doesn't have 22.04 LTS?!
country := fi
ubuntu_mirror := http://$(country).releases.ubuntu.com

# NB: https://torrent.ubuntu.com/tracker_index might also be an option

#
# What images we want to download?
# Look up the filenames at $(ubuntu_mirror)
#

images :=
images += ubuntu-22.04.4-desktop-amd64.iso
images += ubuntu-22.04.4-live-server-amd64.iso
images += ubuntu-24.04-desktop-amd64.iso
images += ubuntu-24.04-live-server-amd64.iso


#
# What upcoming Ubuntu releases we want to track?
# (for 'make show-available' and 'make show-new-available')
#

check_new_releases := 24.04 24.10 25.04 25.10 26.04

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

# Compute outdated files

old_images = $(filter-out $(images),$(wildcard *.iso))
old_sha256sums = $(filter-out $(sha256sums),$(wildcard SHA256SUMS.??.??))
old_sha256sums_gpg = $(filter-out $(sha256sums_gpg),$(wildcard SHA256SUMS.*.gpg))
old_files = $(sort $(old_images) $(old_sha256sums) $(old_sha256sums_gpg))

#
# Rules
#

all: $(sha256sums) $(sha256sums_gpg) $(images)
.PHONY: all

help:
	@echo "make all                     -- download all ISO images"
	@echo "make <filename>.iso          -- download one ISO image"
	@echo "make download-signatures     -- download all SHA256SUMS files"
	@echo "make -B download-signatures  -- redownload all SHA256SUMS files"
	@echo "make urls                    -- print URLs for ISO images and SHA256SUMS files"
	@echo "make show-shasums            -- print SHA256 checksums for all ISO images"
	@echo "make verify-sha256sums       -- verify GPG signatures of all SHA256SUMS files"
	@echo "make verify-SHA256SUMS.<ver> -- verify SHA256 checksums of one SHA256SUMS file"
	@echo "make verify-images           -- verify SHA256 checksums of all ISO images"
	@echo "make verify-<filename>.iso   -- verify SHA256 checksums of one ISO image"
	@echo "make verify-all              -- verify all of the above"
	@echo "make show-old-files          -- show old ISO/SHA256SUM/GPG signature files"
	@echo "make clean-old-files         -- remove old ISO/SHA256SUM/GPG signature files"
	@echo "make show-available          -- look for available images in the mirror"
	@echo "make show-new-available      -- look for available images in the mirror"
	@echo "                                that haven't been downloaded yet"
	@echo
	@echo "Default set of images:"
	@printf "  %s\n" $(images)
.PHONY: help

download-signatures: $(sha256sums) $(sha256sums_gpg)
.PHONY: download-signatures

urls: $(sha256sums:=.url) $(sha256sums_gpg:=.url) $(images:=.url)
.PHONY: urls

verify-sha256sums: $(foreach fn,$(sha256sums),verify-$(fn))
.PHONY: verify-sha256sums

show-shasums: $(foreach fn,$(images),show-$(fn)-shasum)
.PHONY: show-shasums

verify-images: $(foreach fn,$(images),verify-$(fn))
.PHONY: verify-images

verify-all: verify-sha256sums verify-images
.PHONY: verify-all

.PHONY: show-old-files
show-old-files:
	@printf "%s\n" $(old_files)

.PHONY: clean-old-files
clean-old-files:
	rm -f $(old_files)

.PHONY: show-available
show-available:
	@for release in $(sort $(releases) $(check_new_releases)); do \
	    curl -sf $(ubuntu_mirror)/$$release/SHA256SUMS | cut -c 67-; \
	done | grep -v ^$$ || true

.PHONY: show-new-available
show-new-available:
	@for release in $(sort $(releases) $(check_new_releases)); do \
	    curl -sf $(ubuntu_mirror)/$$release/SHA256SUMS | cut -c 67-; \
	done | while read filename; do \
	    if [ -n "$$filename" ] && ! [ -e "$$filename" ]; then \
	        printf "%s\n" "$$filename"; \
	    fi; \
	done


SHA256SUMS.%:
	wget $(ubuntu_mirror)/$*/SHA256SUMS -O $@

SHA256SUMS.%.url:
	@echo $(ubuntu_mirror)/$*/SHA256SUMS

SHA256SUMS.%.gpg:
	wget $(ubuntu_mirror)/$*/SHA256SUMS.gpg -O $@

SHA256SUMS.%.gpg.url:
	@echo $(ubuntu_mirror)/$*/SHA256SUMS.gpg

ubuntu-%.iso:
	wget -c $(ubuntu_mirror)/$(call release,$*)/$@

ubuntu-%.iso.url:
	@echo $(ubuntu_mirror)/$(call release,$*)/ubuntu-$*.iso

verify-SHA256SUMS.%: SHA256SUMS.% SHA256SUMS.%.gpg
	$(verify) SHA256SUMS.$*.gpg SHA256SUMS.$*

.SECONDEXPANSION:
verify-ubuntu-%.iso: SHA256SUMS.$$(call release,$$*) ubuntu-%.iso
	@grep $(@:verify-%=%) $< | sha256sum -c -

.SECONDEXPANSION:
show-ubuntu-%.iso-shasum: SHA256SUMS.$$(call release,$$*)
	@grep $(@:show-%-shasum=%) $<

.PRECIOUS: %.iso SHA256SUMS.%
