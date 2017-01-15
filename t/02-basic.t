

use v6;
use Test;

use GTK::Simple::App;
use GTK::Scintilla;
use GTK::Scintilla::Editor;

# Test data
my @lines = [ "Line #0\n", "Line #1\n", "Line #2" ];

plan 27 + @lines.elems * 2;

# Test version method
my $version = GTK::Scintilla.version;
say $version;
ok( $version<major>  == 3,       "Major version match" );
ok( $version<minor>  == 7,       "Minor version match" );
ok( $version<patch>  == 2,       "Patch version match" );
ok( $version<string> eq "3.7.2", "Version string match" );

# Create GTK application
my $app = GTK::Simple::App.new(title => "Hello GTK + Scintilla!");

# Create editor widget
my $editor = GTK::Scintilla::Editor.new;
$editor.size-request(500, 300);
$app.set-content($editor);

# Test set-text, get-text and get-text-length equality
my $text = @lines.join("");
$editor.set-text($text);
ok( $editor.get-text        eq $text,       "get and set text works" );
ok( $editor.get-text-length eq $text.chars, "get-text-length works");

# Test append-text
my $text-at-the-end = "ABC\n";
$editor.append-text("ABC\n");
ok( $editor.get-text.ends-with($text-at-the-end), ".append-text works" );

# Test delete-range
$editor.set-text($text);
$editor.delete-range(1, 5);
my $text-after-delete = $text.substr(0, 1) ~ $text.substr(6);
ok( $editor.get-text eq $text-after-delete, ".delete-range works");

# Test get-char-at
$editor.set-text($text);
diag $editor.get-char-at(0);
ok( $editor.get-char-at(0)  eq $text.comb[0], "get-char-at(0) works");
ok( $editor.get-char-at(5)  eq $text.comb[5], "get-char-at(5) works");
ok( $editor.get-char-at(-1) eq "",            "invalid position returns empty string");

# Test get-line-length and get-line return values
$editor.set-text($text);
my $num-lines = @lines.elems;
for 0..@lines.elems - 1 -> $i {
    my $line = @lines[$i];
    ok( $editor.get-line-length($i) == $line.chars, "get-line-length($i) works");
    ok( $editor.get-line($i)        eq $line,       "get-line($i) works");
}

# Test get-line-count
ok($editor.get-line-count == $num-lines, "get-line-count works");

# Test out-of-range indices for get-line-length and get-line
ok($editor.get-line-length(-1)         eq 0,  "get-line(-1) must return zero");
ok($editor.get-line(-1)                eq "", "get-line(-1) must return empty string");
ok($editor.get-line-length($num-lines) eq 0,  "get-line($num-lines) must return also zero");
ok($editor.get-line($num-lines)        eq "", "get-line($num-lines) must return also empty string");

# TODO Test set-save-point
#$editor.set-save-point;

$editor.clear-all;
ok($editor.get-text-length == 0, "clear-all & get-text-length works");
ok($editor.get-text        eq "", "clear-all & get-text works");
ok($editor.get-line-count  == 1, "clear-all & get-line-count works");

#TODO test style-get-bold
#TODO test style-set-bold

# Before an undo
ok( $editor.can-undo, "can-undo is True");
ok( not $editor.can-redo, "can-redo is False");

# After an undo
$editor.undo;
ok( $editor.can-undo, "can-undo is False");
ok( $editor.can-redo, "can-redo is True");
ok( $editor.get-text eq $text, "undo works" );

# After a redo
$editor.redo;
ok( $editor.get-text eq "", "redo works" );

# After an empty-undo-buffer
$editor.empty-undo-buffer;
ok( !$editor.can-undo, "empty-undo-buffer works");

# Test begin and undo action (aka transaction)
$editor.clear-all;
$editor.begin-undo-action;
$editor.set-text("ABC\n");
$editor.append-text("DEF\n");
$editor.end-undo-action;
$editor.undo;
ok( $editor.get-text eq "", "begin and end undo action work");
