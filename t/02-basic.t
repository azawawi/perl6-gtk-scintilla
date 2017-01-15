

use v6;
use Test;

use GTK::Simple::App;
use GTK::Scintilla;
use GTK::Scintilla::Editor;

# Test data
my @lines = [ "Line #0\n", "Line #1\n", "Line #2" ];

plan 38 + @lines.elems * 2;

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
ok($editor.get-text-length == 0,  "clear-all & get-text-length works");
ok($editor.get-text        eq "", "clear-all & get-text works");
ok($editor.get-line-count  == 1,  "clear-all & get-line-count works");

# Test set/get bold style
$editor.style-set-bold(0, True);
ok( $editor.style-get-bold(0), "set, get bold works");

# Before an undo
ok( $editor.can-undo,     "can-undo is True");
ok( not $editor.can-redo, "can-redo is False");

# After an undo
$editor.undo;
ok( $editor.can-undo,          "can-undo is False");
ok( $editor.can-redo,          "can-redo is True");
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

# Test selection
{
    constant SELECTION-START = 1;
    constant SELECTION-END   = 5;

    $editor.set-text($text);
    $editor.set-selection-start(SELECTION-START);
    $editor.set-selection-end(SELECTION-END);
    ok( $editor.get-selection-start == SELECTION-START &&
        $editor.get-selection-end   == SELECTION-END,
        "set/get selection start/end works");

    $editor.select-all;
    ok( $editor.get-selection-start == 0 &&
        $editor.get-selection-end   == $text.chars, "select-all works");

    $editor.set-empty-selection(SELECTION-END);
    ok( $editor.get-selection-start == SELECTION-END &&
        $editor.get-selection-end   == SELECTION-END, "set-empty-selection works");
}

# Test set/get read only
{
    ok( !$editor.get-read-only, "By default the document is not read-only");
    $editor.set-read-only(True);
    ok( $editor.get-read-only,  "set/get read-only works");
    $editor.set-read-only(False);
}

# Test cut, copy, clear and paste
{
    constant TEXT = "Hello world";

    $editor.clear-all;
    $editor.copy-text(TEXT);
    $editor.paste;
    ok( $editor.get-text, TEXT);

    ok( $editor.can-paste, "can-paste is True on a non-readonly document");
    $editor.set-read-only(True);
    ok( !$editor.can-paste, "can-paste is False on a readonly document");
    $editor.set-read-only(False);
}

# Test get/set cursor
{
    ok( $editor.get-cursor == Normal, "By default, cursor is normal" );
    $editor.set-cursor(Wait);
    ok( $editor.get-cursor == Wait, "set/get cursor works" );
    $editor.set-cursor(Normal);
}
