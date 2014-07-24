# Unix makefile for the JBIG-KIT library

# Select an ANSI/ISO C compiler here, GNU gcc is recommended
CC = gcc

# Options for the compiler: A high optimization level is suggested
CFLAGS ?= -g -O -W -Wall -ansi -pedantic # --coverage

.PHONY: all clean test

%.lo %.o: %.c
	libtool --mode=compile $(CC) $(CFLAGS) $(CPPFLAGS) -c $<

all: libjbig.la

tstcodec: tstcodec.o libjbig.a
	$(CC) $(LDFLAGS) $(CFLAGS) -o tstcodec $+

tstcodec85: tstcodec85.o libjbig.a
	$(CC) $(LDFLAGS) $(CFLAGS) -o tstcodec85 $+

libjbig.a: libjbig.la
	cp .libs/libjbig.a .

libjbig.la: jbig.lo jbig_ar.lo jbig85.lo
	libtool --mode=link $(CC) $(LDFLAGS) -o libjbig.la $+ -rpath /usr/lib

jbig.lo: jbig.c jbig.h jbig_ar.h
jbig85.lo: jbig85.c jbig85.h jbig_ar.h
jbig_ar.lo: jbig_ar.c jbig_ar.h
tstcodec.o: tstcodec.c libjbig.a jbig.h
tstcodec85.o: tstcodec85.c libjbig.a jbig85.h

update-po: jbig.c jbig85.c Makefile
	xgettext -ojbig.pot -k_ \
	  --copyright-holder='Markus Kuhn' \
	  --msgid-bugs-address='http://www.cl.cam.ac.uk/~mgk25/jbigkit/' \
	  --package-name jbigkit \
	jbig.c jbig85.c
	cd po && for po in *.po ; do \
	  msgmerge --update $$po ../jbig.pot ; done

analyze:
	clang --analyze *.c

test: tstcodec tstcodec85
	./tstcodec
	./tstcodec85

t82test.pbm: tstcodec
	./tstcodec $@

clean:
	rm -rf .libs
	rm -f *.gcda *.gcno *.gcov *.a *.la *.o *.lo *~ core gmon.out dbg_d\=??.pbm t82test.pbm
	rm -f t82test.pbm
	rm -f tstcodec tstcodec85
