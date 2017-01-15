use v6;

use NativeCall;
use GTK::Scintilla;
use GTK::Scintilla::Raw;
use GTK::Simple::Widget;

unit class GTK::Scintilla::Editor does GTK::Simple::Widget;


submethod BUILD(Int $id = 0) {
    $!gtk_widget = gtk_scintilla_new;
    gtk_scintilla_set_id($!gtk_widget, $id);
}

method style-clear-all {
    gtk_scintilla_send_message($!gtk_widget, 2050, 0, 0);
}

method style-set-foreground(Int $style, Int $color) {
    gtk_scintilla_send_message($!gtk_widget, 2051, $style, $color);
}

method style-set-bold(Int $style, Bool $bold) {
    gtk_scintilla_send_message($!gtk_widget, 2053, $style, $bold ?? 1 !! 0);
}

method style-get-bold(Int $style) returns Bool {
    return gtk_scintilla_send_message($!gtk_widget, 2483, $style, 0) == 1;
}

method set-lexer(Int $lexer) {
    gtk_scintilla_send_message($!gtk_widget, 4001, $lexer, 0);
}

##
## Text retrieval and modification
##

#
# SCI_INSERTTEXT(int pos, const char *text)
#
method insert-text(Int $pos, Str $text) {
    gtk_scintilla_send_message_str($!gtk_widget, 2003, $pos, $text);
}

#
# SCI_GETTEXTLENGTH => int
#
method get-text-length() returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2183, 0, 0);
}

#
# SCI_SETTEXT(<unused>, const char *text)
#
method set-text(Str $text) {
    gtk_scintilla_send_message_str($!gtk_widget, 2181, 0, $text);
}


#
# SCI_GETTEXT(int length, char *text NUL-terminated) => int
#
method get-text() returns Str {
    my $buffer-length = self.get-text-length + 1;
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
method set-save-point() {
    gtk_scintilla_send_message($!gtk_widget, 2014, 0, 0);
    return;
}

#
# SCI_GETLINE(int line, char *text) → int
#
# This fills the buffer defined by text with the contents of the nominated line
# (lines start at 0)
#
method get-line(Int $line) returns Str {
    my $buffer-length = self.get-line-length($line) + 1;
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
# SCI_LINELENGTH(int line) → int
#
# This returns the length of the line, including any line end characters. If
# line is negative or beyond the last line in the document, the result is 0. If
# you want the length of the line not including any end of line characters, use
# SCI_GETLINEENDPOSITION(line) - SCI_POSITIONFROMLINE(line).
#
method get-line-length(Int $line) returns Int {
    return gtk_scintilla_send_message($!gtk_widget, 2350, $line, 0);
}

#
# Unless the document is read-only, this deletes all the text.
#
method clear-all {
    return gtk_scintilla_send_message($!gtk_widget, 2004, 0, 0);
}

method get-line-count {
    return gtk_scintilla_send_message($!gtk_widget, 2154, 0, 0);
}

##
##  Long line API
##

#
# SCI_SETEDGEMODE(int edgeMode)
# SCI_GETEDGEMODE
#
method set-edge-mode(Int $edge-mode) {
    gtk_scintilla_send_message($!gtk_widget, 2363, $edge-mode, 0);
}

method get-edge-mode returns Int {
    gtk_scintilla_send_message($!gtk_widget, 2362, 0, 0);
}

#
# SCI_SETEDGECOLUMN(int column)
# SCI_GETEDGECOLUMN
#
method set-edge-column(Int $column) {
    gtk_scintilla_send_message($!gtk_widget, 2361, $column, 0);
}

method get-edge-column returns Int {
    gtk_scintilla_send_message($!gtk_widget, 2360, 0, 0);
}

#
# SCI_SETEDGECOLOUR(int colour)
# SCI_GETEDGECOLOUR
#
method set-edge-color(Int $color) {
    gtk_scintilla_send_message($!gtk_widget, 2365, $color, 0);
}

method get-edge-color returns Int {
    gtk_scintilla_send_message($!gtk_widget, 2364, 0, 0);
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
}

method zoom-out {
    gtk_scintilla_send_message($!gtk_widget, 2334, 0, 0);
}

method set-zoom(Int $zoom-in-points) {
    gtk_scintilla_send_message($!gtk_widget, 2373, $zoom-in-points, 0);
}

method get-zoom returns Int {
    gtk_scintilla_send_message($!gtk_widget, 2374, 0, 0);
}

=begin pod

=head1 Name

GTK::Scintilla::Editor - GTK Scintilla Editor Widget

=head1 Synopsis

TODO Add Synopsis ection documentation

=head1 Description

TODO Add Description section documentation

=head1 Methods

=head2 Long lines

Please see L<here|http://www.scintilla.org/ScintillaDoc.html#LongLines>.

=head3 set-edge-mode

=head3 get-edge-mode

=head3 set-edge-column

=head3 get-edge-column

=head3 set-edge-color

=head3 get-edge-color


=head2 Zooming

Please see L<here|http://www.scintilla.org/ScintillaDoc.html#Zooming>.

=head3 zoom-in

=head3 zoom-out

=head3 set-zoom

=head3 get-zoom

=end pod
