

use v6;
use Test;

use GTK::Simple::App;
use GTK::Scintilla;
use GTK::Scintilla::Editor;

# Test data
my @lines = [ "Line #0\n", "Line #1\n", "Line #2\n" ];

plan 9 + @lines.elems * 2;

# Test version method
my $version = GTK::Scintilla.version;
say $version;
ok( $version<major>  == 3, "Major version match" );
ok( $version<minor>  == 7, "Minor version match" );
ok( $version<patch>  == 2, "Patch version match" );
ok( $version<string> eq "3.7.2", "Version string match" );

# Create GTK application
my $app = GTK::Simple::App.new(title => "Hello GTK + Scintilla!");

# Create editor widget
my $editor = GTK::Scintilla::Editor.new;
$editor.size-request(500, 300);
$app.set-content($editor);

# Test set-text and get-text equality
my $text = @lines.join("");
$editor.set-text($text);
ok( $editor.get-text  eq $text, "get and set text works" );

# Test get-line-length and get-line return values
my $num-lines = @lines.elems;
for 0..@lines.elems - 1 -> $i {
    my $line = @lines[$i];
    ok( $editor.get-line-length($i) == $line.chars,
        "get-line-length($i) works");
    ok( $editor.get-line($i) eq $line, "get-line($i) works");
}

# Test out-of-range indices for get-line-length and get-line
ok($editor.get-line-length(-1) eq 0, "get-line(-1) must return zero");
ok($editor.get-line(-1) eq "", "get-line(-1) must return empty string");
ok($editor.get-line-length($num-lines) eq 0, "get-line($num-lines) must return also zero");
ok($editor.get-line($num-lines) eq "", "get-line($num-lines) must return empty also string");

# TODO Test set-save-point
#$editor.set-save-point;
