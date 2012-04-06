# Unix makefile for JBIG-KIT
# $Id: Makefile 1303 2008-08-30 20:16:20Z mgk25 $

# Select an ANSI/ISO C compiler here, GNU gcc is recommended
CC = gcc

# Options for the compiler: A high optimization level is suggested
CCFLAGS = -O2 -W
#CCFLAGS = -O -g -W -Wall -ansi -pedantic #-DDEBUG  # developer only

CFLAGS = $(CCFLAGS) -I../libjbig

VERSION=2.0
.PHONY: all lib pbm test clean install

all: lib pbm

lib:
	(cd libjbig;  make "CC=$(CC)" "CFLAGS=$(CFLAGS)")

pbm: lib
	(cd pbmtools; make "CC=$(CC)" "CFLAGS=$(CFLAGS)")

test: lib pbm
#	(cd libjbig;  make "CC=$(CC)" "CFLAGS=$(CFLAGS)" test)
#	(cd pbmtools; make "CC=$(CC)" "CFLAGS=$(CFLAGS)" test)

clean:
	rm -f *~ core
	(cd libjbig; make clean)
	(cd pbmtools; make clean)

install: all
	install -d $(DESTDIR)/usr/lib/$(DEB_HOST_MULTIARCH)
	install -s -m 644 libjbig/.libs/*.so.*.*.* libjbig/.libs/*.a $(DESTDIR)/usr/lib/$(DEB_HOST_MULTIARCH)
	install -m 644 libjbig/.libs/*.la $(DESTDIR)/usr/lib/$(DEB_HOST_MULTIARCH)
	/sbin/ldconfig -n $(DESTDIR)/usr/lib/$(DEB_HOST_MULTIARCH)
	ln -s /usr/lib/$(DEB_HOST_MULTIARCH)/libjbig.so.0.0
	install -d $(DESTDIR)/usr/include
	install -m 644 libjbig/*.h $(DESTDIR)/usr/include
	install -d $(DESTDIR)/usr/bin
	install -s -m 755 pbmtools/jbgtopbm pbmtools/jbgtopbm85 pbmtools/pbmtojbg pbmtools/pbmtojbg85 $(DESTDIR)/usr/bin
	install -d $(DESTDIR)/usr/share/man/man1
	install -m 644 pbmtools/*.1 $(DESTDIR)/usr/share/man/man1
