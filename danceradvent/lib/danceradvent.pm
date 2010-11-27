package danceradvent;
use Dancer ':syntax';
use Dancer::Plugin::DebugDump;
use Pod::POM;
use Pod::POM::View::InlineHTML;
use POSIX qw/strftime/;
our $VERSION = '0.1';

my $article_dir = Dancer::FileUtils::path(
    setting('appdir'), 'public', 'articles'
);

before sub {
    vars->{current_year} = 2010; # TODO: replace with code that finds
                                 # the last advent calendar season
                                 # to lazy for date math now
};

get '/' => sub {
    my $current_year = vars->{current_year};
    redirect("/$current_year");
};

get '/notyet' => sub {
    template 'notyet';
};

get '/:year' => sub {
    return send_error( "this is not a valid year", 404 )
      unless _control_date( params->{year} );

    my @articles;

    # randomly chosen
    my @days = (
        19, 12, 6, 4,  13, 22, 17, 3, 23, 21, 9,  16,
        24, 11, 5, 10, 15, 20, 7,  8, 14, 1,  18, 2,
    );
    for my $day (@days) {

        push @articles, {

            # _article_viewable should check if there is an article available
            # and if 201012$day <= $current_date
            viewable => _article_viewable( params->{year}, $day ),

            #viewable => $day <= 5 ? 1 : 0, # TODO: fixme
            day => $day,
        };
    }
    return template 'index' =>
      { year => params->{year}, articles => \@articles };
};

get '/:year/:day' => sub {
    # XXX better 404 page for this
    return send_error( "this is not valid date", 404 )
      unless _control_date( params->{year}, params->{day} );

    my $year = params->{year};
    my $day  = params->{day};

    return template 'notyet' unless ( _article_viewable( $year, $day ) );

    my ($pod_file) = _article_exists( $year, $day );

    return send_error( "No such article", 404 ) if ( !defined $pod_file );

    my $article_pod = Dancer::FileUtils::read_file_content($pod_file);

    my $parser = Pod::POM->new;
    my $pom    = $parser->parse($article_pod);

    # fetch the title
    my $title = $pom->head1;
    if ( $title && $title->[0] ) {
        $title = $title->[0]->title;
    }

    my $html = Pod::POM::View::InlineHTML->print($pom);

    return template article => {
        title => $title || "Perl Dancer Advent Calendar",
        content => $html
    };
};

sub _article_viewable {
    my ($year, $day) = @_;
    my $date = sprintf "%04d12%02d", $year, $day;
    # using gmtime
    my $today = strftime "%Y%m%d", gmtime(time);

    if (setting('render_future')) {
        $today = sprintf "%04d12%02d", $year, 24;
    }

    debug("Deciding whether $date is viewable on $today");
    if($date <= $today) {
        return defined _article_exists($year, $day);
    }

    return undef
}

sub _control_date {
    my ( $year, $day ) = @_;
    my $valid = 1;
    $valid = 0 if $year !~ /^\d{4}$/;
    $valid = 0 if ( $day && $day !~ /^\d\d?$/ );
    return $valid;
}

sub _article_exists {
    my ($year, $day) = @_;

    my ($file) = glob("$article_dir/${year}/${day}-*.pod");
    if(defined $file) {
        return $file;
    }

    return undef;
}

true;
