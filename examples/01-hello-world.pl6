#!/usr/bin/env perl6

use v6;

use GTK::Simple::App;
use GTK::Simple::Raw;
use GTK::Scintilla;
use GTK::Scintilla::Editor;

my $app = GTK::Simple::App.new(title => "Hello GTK + Scintilla!");

my $editor = GTK::Scintilla::Editor.new;
gtk_widget_set_size_request($editor.WIDGET, 500, 300);
$app.set-content($editor);

$editor.style-clear-all;
$editor.style-set-foreground(SCE_PL_COMMENTLINE, 0x008000);
$editor.style-set-foreground(SCE_PL_POD, 0x008000);
$editor.style-set-foreground(SCE_PL_NUMBER, 0x808000);
$editor.style-set-foreground(SCE_PL_WORD, 0x800000);
$editor.style-set-foreground(SCE_PL_STRING, 0x800080);
$editor.style-set-foreground(SCE_PL_OPERATOR, 1);
$editor.insert-text(0, qq{# A comment\nuse Modern::Perl;\nsay "Hello world"\n} );

gtk_widget_show($editor);

$app.run;
