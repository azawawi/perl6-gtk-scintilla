use v6;

use NativeCall;
use GTK::Scintilla;
use GTK::Scintilla::Raw;
use GTK::Simple::Widget;

unit class GTK::Scintilla::Editor does GTK::Simple::Widget;

=begin pod

=head1 Name

GTK::Scintilla::Editor - GTK Scintilla Editor Widget

=head1 Synopsis

TODO Add Synopsis section documentation

=head1 Description

TODO Add Description section documentation

=head1 Methods

=end pod

submethod BUILD(Int $id = 0) {
    $!gtk_widget = gtk_scintilla_new;
    gtk_scintilla_set_id($!gtk_widget, $id);
    return;
}

method style-clear-all {
    gtk_scintilla_send_message($!gtk_widget, 2050, 0, 0);
    return;
}

method style-foreground(Int $style, Int $color) {
    gtk_scintilla_send_message($!gtk_widget, 2051, $style, $color);
}

multi method style-bold(Int $style, Bool $bold) {
    gtk_scintilla_send_message($!gtk_widget, 2053, $style, $bold ?? 1 !! 0);
    return;
}

multi method style-bold(Int $style) returns Bool {
    return gtk_scintilla_send_message($!gtk_widget, 2483, $style, 0) == 1;
}

multi method lexer(Int $lexer) {
    gtk_scintilla_send_message($!gtk_widget, 4001, $lexer, 0);
    return;
}

##
## Selection and information
##

#
# SCI_SETSELECTIONSTART(int anchor)
#
multi method selection-start(Int $anchor) {
    gtk_scintilla_send_message($!gtk_widget, 2142, $anchor, 0);
    return;
}

#
# SCI_GETSELECTIONSTART → position
#
multi method selection-start() returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2143, 0, 0);
}

#
# SCI_SETSELECTIONEND(int caret)
#
multi method selection-end(Int $caret) {
    gtk_scintilla_send_message($!gtk_widget, 2144, $caret, 0);
    return;
}

#
# SCI_GETSELECTIONEND → position
#
multi method selection-end returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2145, 0, 0);
}

#
# SCI_SETEMPTYSELECTION(int caret)
#
# This removes any selection and sets the caret at caret. The caret is not
# scrolled into view.
#
multi method empty-selection(Int $caret) {
    gtk_scintilla_send_message($!gtk_widget, 2556, $caret, 0);
    return;
}

#
# SCI_SELECTALL
#
method select-all() {
    gtk_scintilla_send_message($!gtk_widget, 2013, 0, 0);
    return;
}


##
## Cut, copy and paste
##

#
# SCI_CUT
#
method cut() {
    gtk_scintilla_send_message($!gtk_widget, 2177, 0, 0);
    return;
}

#
# SCI_COPY
#
method copy() {
    gtk_scintilla_send_message($!gtk_widget, 2178, 0, 0);
    return;
}

#
# SCI_PASTE
#
method paste() {
    gtk_scintilla_send_message($!gtk_widget, 2179, 0, 0);
    return;
}

#
# SCI_CLEAR
#
method clear() {
    gtk_scintilla_send_message($!gtk_widget, 2180, 0, 0);
    return;
}

#
# SCI_CANPASTE → bool
#
method can-paste() {
    return gtk_scintilla_send_message($!gtk_widget, 2173, 0, 0) == 1;
}

#
# SCI_COPYRANGE(int start, int end)
#
method copy-range(Int $start, Int $end) {
    gtk_scintilla_send_message($!gtk_widget, 2419, $start, $end);
    return;
}

#
# SCI_COPYTEXT(int length, const char *text)
#
method copy-text(Str $text) {
    gtk_scintilla_send_message_str($!gtk_widget, 2420, $text.chars, $text);
    return;
}

#
# SCI_COPYALLOWLINE
#
method copy-allow-line() {
    gtk_scintilla_send_message($!gtk_widget, 2519, 0, 0);
    return;
}

#
# SCI_SETPASTECONVERTENDINGS(bool convert)
#
multi method paste-convert-endings(Bool $convert) {
    gtk_scintilla_send_message($!gtk_widget, 2467, $convert ?? 1 !! 0, 0);
    return;
}

#
# SCI_GETPASTECONVERTENDINGS → bool
#
multi method paste-convert-endings(Bool $convert) {
    return gtk_scintilla_send_message($!gtk_widget, 2468, 0, 0) == 1;
}

##
## Text retrieval and modification
##

#
# SCI_INSERTTEXT(int pos, const char *text)
#
method insert-text(Int $pos, Str $text) {
    gtk_scintilla_send_message_str($!gtk_widget, 2003, $pos, $text);
    return;
}

#
# SCI_APPENDTEXT(int length, const char *text)
#
method append-text(Str $text) {
    gtk_scintilla_send_message_str($!gtk_widget, 2282, $text.chars, $text);
    return;
}

=begin pod

=head3 add-text(Str $text)

Add text to the document at current position.

=end pod
method add-text(Str $text) {
    gtk_scintilla_send_message_str($!gtk_widget, 2001, $text.chars, $text);
    return;
}

=begin pod

=head3 delete-range(Int $start, Int $length)

Delete a range of text in the document.

=end pod
method delete-range(Int $start, Int $length) {
    gtk_scintilla_send_message($!gtk_widget, 2645, $start, $length);
    return;
}

#
# SCI_GETCHARAT(int pos) → int
#
multi method char-at(Int $position) returns Str {
    my $ch = gtk_scintilla_send_message($!gtk_widget, 2007, $position, 0);
    #TODO fire exception?
    return $ch != 0 ?? chr($ch) !! "";
}

=begin pod
=head3 length()

Returns the number of bytes in the document.

=end pod
method length() returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2006, 0, 0);
}

#
# SCI_GETTEXTLENGTH => int
#
multi method text-length returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2183, 0, 0);
}

=begin pod

=head3 current-pos

Returns the position of the caret.

=end pod
multi method current-pos returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2008, 0, 0);
}

=begin pod

=head3 current-pos(Int $caret)

Sets the position of the caret.

=end pod
multi method current-pos(Int $caret) {
    gtk_scintilla_send_message($!gtk_widget, 2141, $caret, 0);
    return;
}

=begin pod

=head3 text(Str $text)

Replace the contents of the document with the argument text.

=end pod
multi method text(Str $text) {
    gtk_scintilla_send_message_str($!gtk_widget, 2181, 0, $text);
    return;
}

=begin pod

=head3 text()

Returns all the text in the document.

=end pod
multi method text() returns Str {
    my $buffer-length = self.text-length + 1;
    my $buffer = CArray[uint8].new;
    $buffer[$buffer-length - 1] = 0;
    my $len = gtk_scintilla_send_message_carray($!gtk_widget, 2182,
        $buffer-length, $buffer);
    my $text = '';
    for 0..$buffer-length - 2 -> $i {
        $text ~= chr($buffer[$i]);
    }
    return $text;
}

#
# SCI_SETSAVEPOINT()
#
# This message tells Scintilla that the current state of the document is
# unmodified. This is usually done when the file is saved or loaded, hence the
# name "save point".
#
multi method save-point() {
    gtk_scintilla_send_message($!gtk_widget, 2014, 0, 0);
    return;
}

#
# SCI_GETLINE(int line, char *text) → int
#
# This fills the buffer defined by text with the contents of the nominated line
# (lines start at 0)
#
multi method line(Int $line) returns Str {
    my $buffer-length = self.line-length($line) + 1;
    my $buffer = CArray[uint8].new;
    $buffer[$buffer-length - 1] = 0;
    my $len = gtk_scintilla_send_message_carray($!gtk_widget, 2153,
        $line, $buffer);
    my $text = '';
    for 0..$buffer-length - 2 -> $i {
        $text ~= chr($buffer[$i]);
    }
    return $text;
}

#
# SCI_SETREADONLY(bool readOnly)
#
multi method read-only(Bool $read-only) {
    gtk_scintilla_send_message($!gtk_widget, 2171, $read-only ?? 1 !! 0, 0);
    return;
}

#
# SCI_GETREADONLY → bool
#
multi method read-only returns Bool {
    return gtk_scintilla_send_message($!gtk_widget, 2140, 0, 0) == 1;
}

#
# SCI_LINELENGTH(int line) → int
#
# This returns the length of the line, including any line end characters. If
# line is negative or beyond the last line in the document, the result is 0. If
# you want the length of the line not including any end of line characters, use
# SCI_GETLINEENDPOSITION(line) - SCI_POSITIONFROMLINE(line).
#
multi method line-length(Int $line) returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2350, $line, 0);
}

=begin pod

=head2 clear-all

Delete all text in the document unless the document is read-only.

=end pod
method clear-all {
    gtk_scintilla_send_message($!gtk_widget, 2004, 0, 0);
    return;
}

multi method line-count {
    return gtk_scintilla_send_message($!gtk_widget, 2154, 0, 0);
}

=begin pod

=head2 Long lines

Please see L<here|http://www.scintilla.org/ScintillaDoc.html#LongLines>.

=end pod
#
# SCI_SETEDGEMODE(int edgeMode)
# SCI_GETEDGEMODE
#
=begin pod

=head3 edge-mode

=end pod
multi method edge-mode(Int $edge-mode) {
    gtk_scintilla_send_message($!gtk_widget, 2363, $edge-mode, 0);
}

=begin pod

=head3 edge-mode

=end pod
multi method edge-mode returns Int {
    gtk_scintilla_send_message($!gtk_widget, 2362, 0, 0);
}

#
# SCI_SETEDGECOLUMN(int column)
# SCI_GETEDGECOLUMN
#
=begin pod

=head3 edge-column

=end pod
multi method edge-column(Int $column) {
    gtk_scintilla_send_message($!gtk_widget, 2361, $column, 0);
    return;
}

=begin pod

=head3 edge-column

=end pod
multi method edge-column returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2360, 0, 0);
}

#
# SCI_SETEDGECOLOUR(int colour)
# SCI_GETEDGECOLOUR
#
=begin pod

=head3 edge-color

=end pod
multi method edge-color(Int $color) {
    gtk_scintilla_send_message($!gtk_widget, 2365, $color, 0);
    return;
}

=begin pod

=head3 get-edge-color

=end pod
multi method edge-color returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2364, 0, 0);
}

##
## Zoom API
##

# SCI_ZOOMIN
# SCI_ZOOMOUT
# SCI_SETZOOM(int zoomInPoints)
# SCI_GETZOOM
#
method zoom-in {
    gtk_scintilla_send_message($!gtk_widget, 2333, 0, 0);
    return;
}

method zoom-out {
    gtk_scintilla_send_message($!gtk_widget, 2334, 0, 0);
    return;
}

multi method zoom(Int $zoom-in-points) {
    gtk_scintilla_send_message($!gtk_widget, 2373, $zoom-in-points, 0);
    return;
}

multi method zoom returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2374, 0, 0);
}


#
# SCI_UNDO
#
method undo() {
    gtk_scintilla_send_message($!gtk_widget, 2176, 0, 0);
    return;
}

#
# SCI_CANUNDO → bool
#
method can-undo returns Bool {
    return gtk_scintilla_send_message($!gtk_widget, 2174, 0, 0) == 1;
}


#
# SCI_EMPTYUNDOBUFFER
#
method empty-undo-buffer() {
    gtk_scintilla_send_message($!gtk_widget, 2175, 0, 0);
    return;
}

#
# SCI_REDO
#
method redo() {
    gtk_scintilla_send_message($!gtk_widget, 2011, 0, 0);
    return;
}

#
# SCI_CANREDO → bool
#
method can-redo returns Bool {
    return gtk_scintilla_send_message($!gtk_widget, 2016, 0, 0) == 1;
}

#
# SCI_SETUNDOCOLLECTION(bool collectUndo)
#
multi method undo-collection(Bool $collect-undo) {
    gtk_scintilla_send_message($!gtk_widget, 2012, $collect-undo ?? 1 !! 0, 0);
    return;
}

#
# SCI_GETUNDOCOLLECTION → bool
#
multi method undo-collection returns Bool {
    return gtk_scintilla_send_message($!gtk_widget, 2019, 0, 0) == 1;
}

#
# SCI_BEGINUNDOACTION
#
method begin-undo-action {
    gtk_scintilla_send_message($!gtk_widget, 2078, 0, 0);
    return;
}

#
# SCI_ENDUNDOACTION
#
method end-undo-action {
    gtk_scintilla_send_message($!gtk_widget, 2079, 0, 0);
    return;
}

#
# SCI_ADDUNDOACTION(int token, int flags)
#
method add-undo-action(Int $token, Int $flags) {
    gtk_scintilla_send_message($!gtk_widget, 2560, $token, $flags);
    return;
}

##
## Cursor
##

#
# SCI_SETCURSOR(int cursorType)
#
multi method cursor(CursorType $cursor-type) {
    gtk_scintilla_send_message($!gtk_widget, 2386, Int($cursor-type), 0);
    return;
}

#
# SCI_GETCURSOR → int
#
multi method cursor returns CursorType {
    my $cursor-type = gtk_scintilla_send_message($!gtk_widget, 2387, 0, 0);
    return CursorType($cursor-type);
}

=begin pod

=head2 Zooming

Please see L<here|http://www.scintilla.org/ScintillaDoc.html#Zooming>.

=head3 zoom-in

=head3 zoom-out

=head3 zoom

=head3 get-zoom

=end pod
