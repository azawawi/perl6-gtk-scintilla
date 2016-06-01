use v6;

use GTK::Simple::Widget;
use GTK::Scintilla;
use GTK::Scintilla::Raw;

unit class GTK::Scintilla::Editor does GTK::Simple::Widget;

submethod BUILD(Int $id = 0) {
    $!gtk_widget = gtk_scintilla_new;
    gtk_scintilla_set_id($!gtk_widget, $id);
}

method style-clear-all {
    gtk_scintilla_send_message($!gtk_widget, SCI_STYLECLEARALL, 0, 0);
}

method style-set-foreground(Int $style, Int $color) {
    gtk_scintilla_send_message($!gtk_widget, SCI_STYLESETFORE, $style, $color);
}

method set-lexer(Int $lexer) {
    gtk_scintilla_send_message($!gtk_widget, SCI_SETLEXER, $lexer, 0);
}

method insert-text(Int $pos, Str $text) {
    gtk_scintilla_send_message_str($!gtk_widget, SCI_INSERTTEXT, $pos, $text);
}

method get-length() {
    gtk_scintilla_send_message($!gtk_widget, SCI_GETTEXTLENGTH, 0, 0);
}

#
# SCI_SETEDGEMODE(int edgeMode)
# SCI_GETEDGEMODE
#
method set-edge-mode(Int $edge-mode) {
    gtk_scintilla_send_message($!gtk_widget, SCI_SETEDGEMODE, $edge-mode, 0);
}

method get-edge-mode returns Int {
    gtk_scintilla_send_message($!gtk_widget, SCI_GETEDGEMODE, 0, 0);
}

#
# SCI_SETEDGECOLUMN(int column)
# SCI_GETEDGECOLUMN
# These messages set and get the column number at which to display the long line
# marker. When drawing lines, the column sets a position in units of the width
# of a space character in STYLE_DEFAULT. When setting the background colour, the
# column is a character count (allowing for tabs) into the line.
#
method set-edge-column(Int $column) {
    gtk_scintilla_send_message($!gtk_widget, SCI_SETEDGECOLUMN, $column, 0);
}

method get-edge-column returns Int {
    gtk_scintilla_send_message($!gtk_widget, SCI_GETEDGECOLUMN, 0, 0);
}

#
# SCI_SETEDGECOLOUR(int colour)
# SCI_GETEDGECOLOUR
# These messages set and get the colour of the marker used to show that a line
# has exceeded the length set by SCI_SETEDGECOLUMN.
#
method set-edge-color(Int $color) {
    gtk_scintilla_send_message($!gtk_widget, SCI_SETEDGECOLOUR, $color, 0);
}

method get-edge-color returns Int {
    gtk_scintilla_send_message($!gtk_widget, SCI_GETEDGECOLOUR, 0, 0);
}
