#!/usr/bin/env perl6

use v6;

use lib 'lib';
use GTK::Simple::App;
use GTK::Simple::VBox;
use GTK::Simple::Button;
use GTK::Scintilla;
use GTK::Scintilla::Editor;

my $app = GTK::Simple::App.new(title => "GTK::Scintilla Events Demo");

my $editor = GTK::Scintilla::Editor.new;
$editor.size-request(500, 300);
$app.set-content(GTK::Simple::VBox.new(
    $editor,
    my $insert-text-top-button = GTK::Simple::Button.new(:label("Insert Top!")),
    my $insert-text-bottom-button = GTK::Simple::Button.new(:label("Insert Bottom!"))
));

$insert-text-top-button.clicked.tap: {
    $editor.insert-text(0, "# a top comment\n");
};

$insert-text-bottom-button.clicked.tap: {
    my $length = $editor.get-length;
    say "Length: $length";
    $editor.insert-text($length, "# a bottom comment\n");
};

$editor.style-clear-all;
$editor.set-lexer(SCLEX_PERL);
$editor.style-set-foreground(SCE_PL_COMMENTLINE, 0x008000);
$editor.style-set-foreground(SCE_PL_POD, 0x008000);
$editor.style-set-foreground(SCE_PL_NUMBER, 0x808000);
$editor.style-set-foreground(SCE_PL_WORD, 0x800000);
$editor.style-set-foreground(SCE_PL_STRING, 0x800080);
$editor.style-set-foreground(SCE_PL_OPERATOR, 1);
$editor.insert-text(0, q{
# A Perl comment
use Modern::Perl;

say "Events Demo";
});

$editor.show;
$app.run;
