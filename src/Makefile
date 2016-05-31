#
# Make file for GTK::Scintilla
#
# Written by Ahmad M. Zawawi <ahmad.zawawi@gmail.com>
#
# This makefile is based on the bait example by Neil Hodgson 
# <neilh@scintilla.org> which was released to the public domain in 2000.
#
.SUFFIXES: .c .o .h .a

INCLUDEDIRS=-Iscintilla/include
CXXFLAGS= -DGTK -DSCI_LEXER -W -Wall
LEXEROBJS=$(wildcard scintilla/gtk/Lex*.o)
GTK_CFLAGS=`pkg-config --cflags gtk+-3.0`
GTK_LDFLAGS=`pkg-config --libs gtk+-3.0 gthread-2.0 gobject-2.0 gmodule-no-export-2.0` -lm -lstdc++

all: clean libwidget.so

widget.o: widget.c
	gcc $(GTK_CFLAGS) $(INCLUDEDIRS) $(CXXFLAGS) -c $^ -fpic -o $@

libwidget.so: widget.o $(LEXEROBJS) scintilla/bin/scintilla.a
	gcc --shared -DGTK $^ -o $@ $(GTK_LDFLAGS)

clean:
	rm -f *.o
	rm -f libwidget.so
