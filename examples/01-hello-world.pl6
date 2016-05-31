#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::Raw;
use GTK::Scintilla;
use GTK::Scintilla::Raw;

my $app = GTK::Simple::App.new(title => "Hello GTK + Scintilla!");

my $editor = gtk_scintilla_new;
gtk_scintilla_set_id($editor, 0);
gtk_widget_set_size_request($editor, 500, 300);
gtk_container_add($app.WIDGET, $editor);

SSM($editor, SCI_STYLECLEARALL, 0, 0);
SSM($editor, SCI_SETLEXER, SCLEX_PERL, 0);
SSM($editor, SCI_SETKEYWORDS, 0, "int char");
SSM($editor, SCI_STYLESETFORE, SCE_PL_COMMENTLINE, 0x008000);
SSM($editor, SCI_STYLESETFORE, SCE_PL_POD, 0x008000);
SSM($editor, SCI_STYLESETFORE, SCE_PL_NUMBER, 0x808000);
SSM($editor, SCI_STYLESETFORE, SCE_PL_WORD, 0x800000);
SSM($editor, SCI_STYLESETFORE, SCE_PL_STRING, 0x800080);
SSM($editor, SCI_STYLESETBOLD, SCE_PL_OPERATOR, 1);
SSM($editor, SCI_INSERTTEXT, 0,
 "# A comment\n" ~
 "use Modern::Perl;\n" ~
 "say \"Hello world\"\n"
);

gtk_widget_show($editor);

$app.run;
