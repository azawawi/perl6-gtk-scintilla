
use v6;

module GTK::Scintilla::Raw;

sub library {
    return %?RESOURCES{"libwidget.so"};
}

sub gtk_scintilla_new returns Pointer is native(&library) { * }

sub gtk_scintilla_set_id(Pointer $sci, int32 $id)
    is native(&library)
    { * }
    
sub gtk_scintilla_send_message(Pointer $sci, uint32 $iMessage, int32 $wParam, int32 $lParam)
    returns Pointer
    is native(&library)
    { * }

sub gtk_scintilla_send_message_str(Pointer $sci, uint32 $iMessage, int32 $wParam, Str $lParam)
    returns Pointer
    is native(&library)
    is symbol('gtk_scintilla_send_message')
    { * }

multi sub SSM(Pointer $sci, Int $iMessage, Int $wParam, Int $lParam)
    returns Pointer
{
    return gtk_scintilla_send_message($sci, $iMessage, $wParam, $lParam);
}

multi sub SSM(Pointer $sci, Int $iMessage, Int $wParam, Str $lParam)
    returns Pointer
{
    return gtk_scintilla_send_message_str($sci, $iMessage, $wParam, $lParam);
}
