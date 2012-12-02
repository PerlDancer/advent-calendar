#!/usr/bin/env perl

BEGIN {
    use FindBin;

    while ( my $libdir = glob("${FindBin::Bin}/../vendor/*/lib") ) {
        unshift @INC, $libdir;
    }

    # Bodge for production box, where git isn't supporting submodules correctly:
    for my $repo (qw(Dancer2 Dancer-Plugin-Feed)) {
        unshift @INC, "/home/davidp/$repo/lib";
    }
}

use Dancer 2.0;
use danceradvent;
dance;
