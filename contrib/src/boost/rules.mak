# BOOST

BOOST_VERSION := 1.57.0
BOOST_VERSION_STR := $(subst .,_,$(BOOST_VERSION))
BOOST_URL := http://sourceforge.net/projects/boost/files/boost/$(BOOST_VERSION)/boost_$(BOOST_VERSION_STR).tar.gz

define JAM_FILE
using gcc : vlc
    : $(CXX)
    : <cxxflags>$(CXXFLAGS)
      <linkflags>$(LDFLAGS)
      <archiver>$(AR)
      <ranlib>$(RANLIB)
;
endef
export JAM_FILE

ifdef HAVE_BSD
BOOST_TARGET := bsd
endif
ifdef HAVE_LINUX
BOOST_TARGET := linux
endif
ifdef HAVE_MACOSX
BOOST_TARGET := darwin
endif
ifdef HAVE_IOS
BOOST_TARGET := iphone
endif
ifdef HAVE_ANDROID
BOOST_TARGET := android
endif
ifdef HAVE_WIN32
BOOST_TARGET := windows
endif
ifdef HAVE_SOLARIS
BOOST_TARGET := solaris
endif

BOOST_CONF := --prefix="$(PREFIX)" \
			  --with-thread \
			  --with-filesystem \
			  --with-date_time \
			  link=static \
			  toolset=gcc-vlc \
			  variant=release \
			  target-os=$(BOOST_TARGET)

ifdef HAVE_WIN32
BOOST_CONF += threadapi=win32
endif

$(TARBALLS)/boost_$(BOOST_VERSION_STR).tar.gz:
	$(call download,$(BOOST_URL))

.sum-boost: boost_$(BOOST_VERSION_STR).tar.gz

boost: boost_$(BOOST_VERSION_STR).tar.gz .sum-boost
	$(UNPACK)
	$(MOVE)

.boost: boost
	echo "$$JAM_FILE" > $</tools/build/src/user-config.jam
	cd $< && ./bootstrap.sh
	cd $< && ./b2 install $(BOOST_CONF)
	touch $@
