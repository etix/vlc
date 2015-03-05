# LIBTORRENT

TORRENT_VERSION := 1.0.3
TORRENT_URL := http://sourceforge.net/projects/libtorrent/files/libtorrent/libtorrent-rasterbar-$(TORRENT_VERSION).tar.gz

ifeq ($(call need_pkg,"libtorrent-rasterbar"),)
PKGS_FOUND += torrent
endif

DEPS_torrent = boost

$(TARBALLS)/libtorrent-rasterbar-$(TORRENT_VERSION).tar.gz:
	$(call download,$(TORRENT_URL))

.sum-torrent: libtorrent-rasterbar-$(TORRENT_VERSION).tar.gz

torrent: libtorrent-rasterbar-$(TORRENT_VERSION).tar.gz .sum-torrent
	$(UNPACK)
	$(MOVE)

.torrent: torrent
	cd $< && find . -name '*.cpp' | xargs sed -i 's/^#include <Win.*\.h>$$/\L&/'
	cd $< && $(HOSTVARS) ./configure $(HOSTCONF) CPPFLAGS="$(CPPFLAGS) -DUNICODE" --with-boost=$(PREFIX) --disable-encryption --disable-geoip
	cd $< && $(MAKE) install
	touch $@
