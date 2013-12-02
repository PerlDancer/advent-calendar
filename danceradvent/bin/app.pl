#!/usr/bin/env perl

BEGIN {
    use FindBin;

    while ( my $libdir = glob("${FindBin::Bin}/../vendor/*/lib") ) {
        warn "$libdir";
        unshift @INC, $libdir;
    }
}

use Dancer2;
use lib 'lib';
use danceradvent;
dance;
