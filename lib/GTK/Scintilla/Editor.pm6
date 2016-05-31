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
