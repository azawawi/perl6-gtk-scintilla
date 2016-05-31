
use v6;
use Test;
use GTK::Scintilla;

plan *;

if %*ENV<DISPLAY> {
    my $g;
    lives-ok { $g = app }
    lives-ok { scheduler.cue: { $g.exit } }
    lives-ok { $g.run }
}

done-testing;
