

use v6;
use Test;

use GTK::Scintilla;

plan 4;

# Check version method
my $version = GTK::Scintilla.version;
say $version;
ok( $version<major>  == 3, "Major version check" );
ok( $version<minor>  == 7, "Minor version check" );
ok( $version<patch>  == 2, "Patch version check" );
ok( $version<string> eq "3.7.2", "Version string check" );
