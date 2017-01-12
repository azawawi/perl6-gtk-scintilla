

use v6;
use Test;

use GTK::Simple::App;
use GTK::Scintilla;
use GTK::Scintilla::Editor;

plan 5;

# Check version method
my $version = GTK::Scintilla.version;
say $version;
ok( $version<major>  == 3, "Major version check" );
ok( $version<minor>  == 7, "Minor version check" );
ok( $version<patch>  == 2, "Patch version check" );
ok( $version<string> eq "3.7.2", "Version string check" );

my $app = GTK::Simple::App.new(title => "Hello GTK + Scintilla!");

my $editor = GTK::Scintilla::Editor.new;
$editor.size-request(500, 300);
$app.set-content($editor);

# Check set-text and get-text
my $text = "1234567890";
$editor.set-text($text);
ok( $editor.get-text  eq $text, "get and set text works" );
