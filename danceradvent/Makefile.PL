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
        'Template'                  => 0,
        'Test::More'                => 0,
        'Text::Outdent'             => 0,
        'URI'                       => 0,
        'YAML'                      => 0,
        
        # Dancer2 deps
        'Capture::Tiny' => 0,
        'Config::Any' => 0,
        'File::Basename' => 0,
        'File::Copy' => 0,
        'File::Find' => 0,
        'File::Spec' => 0,
        'File::Temp' => 0,
        'HTTP::Body' => 0,
        'HTTP::Date' => 0,
        'HTTP::Headers' => 0,
        'HTTP::Request::Common' => 0,
        'HTTP::Server::Simple::PSGI' => 0,
        'JSON::XS' => 0,
        'LWP::UserAgent' => 0,
        'MIME::Types' => 0,
        'MooX::Types::MooseLike' => 0,
        'Plack' => 0,
        'Scalar::Util' => 0,
        'Template' => 0,
        'URI' => 0,
        'YAML::XS' => 0,
        'YAML::Any' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'danceradvent-*' },
);
