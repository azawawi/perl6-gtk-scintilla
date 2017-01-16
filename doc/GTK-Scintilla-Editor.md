Name
====

GTK::Scintilla::Editor - GTK Scintilla Editor Widget

Synopsis
========

TODO Add Synopsis section documentation

Description
===========

TODO Add Description section documentation

Methods
=======

### insert-text(Int $pos, Str $text)

Insert string at a position.

### add-text(Str $text)

Add text to the document at current position.

### delete-range(Int $start, Int $length)

Delete a range of text in the document.

### length()

Returns the number of bytes in the document.

### current-pos

Returns the position of the caret.

### current-pos(Int $caret)

Sets the position of the caret.

### text(Str $text)

Replace the contents of the document with the argument text.

### text

Returns all the text in the document.

clear-all
---------

Delete all text in the document unless the document is read-only.

Long lines
----------

Please see [here](http://www.scintilla.org/ScintillaDoc.html#LongLines).

### edge-mode

### edge-mode

### edge-column

### edge-column

### edge-color

### get-edge-color

Zooming
-------

Please see [here](http://www.scintilla.org/ScintillaDoc.html#Zooming).

### zoom-in

### zoom-out

### zoom

### get-zoom
