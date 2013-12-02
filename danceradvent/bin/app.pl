#!/usr/bin/env perl

BEGIN {
    use FindBin;

    while ( my $libdir = glob("${FindBin::Bin}/../vendor/*/lib") ) {
        unshift @INC, $libdir;
    }

    # BODGE:
    for my $repo (qw(Dancer2 Dancer-Plugin-Feed)) {
        unshift @INC, "/home/davidp/$repo/lib";
    }
}

use Dancer2;
use danceradvent;
dance;
