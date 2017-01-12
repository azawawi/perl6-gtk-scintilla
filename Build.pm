
use v6;

use Panda::Common;
use Panda::Builder;


class Build is Panda::Builder {
    method build($work-dir) {
        my $make-file-dir = "$work-dir/src";
        my $dest-dir = "$work-dir/resources";
        $dest-dir.IO.mkdir;

        shell("cd $make-file-dir && make clean && make");
    }
}
