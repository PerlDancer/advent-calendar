use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'danceradvent',
    AUTHOR              => q{YOUR NAME <youremail@example.com>},
    VERSION_FROM        => 'lib/danceradvent.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Dancer'                    => 1.2000,
        'Dancer::Plugin::DebugDump' => 0,
        'Dancer::Plugin::MobileDevice' => 0,
        'Dancer::Plugin::Feed'      => 0,
        'DateTime'                  => 0,
        'Pod::POM'                  => 0,
        'POSIX'                     => 0,
        'Test::More'                => 0,
        'Text::Outdent'             => 0,
        'URI'                       => 0,
        'YAML'                      => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'danceradvent-*' },
);
